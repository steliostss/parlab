#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <sys/time.h>
// #include "mpi.h"
#include "utils.h"
#include "/usr/include/mpi/mpi.h"

#define TEST_CONV

void Jacobi(double ** u_previous, double ** u_current, int X_min, int X_max, int Y_min, int Y_max);

int main(int argc, char ** argv) {
    int rank,size;
    int global[2],local[2]; //global matrix dimensions and local matrix dimensions (2D-domain, 2D-subdomain)
    int global_padded[2];   //padded global matrix dimensions (if padding is not needed, global_padded=global)
    int grid[2];            //processor grid dimensions
    int i,j,t;
                            //flags for convergence
    int global_converged=0; //global convergence
    int converged=0;        //convergence per process 

    MPI_Datatype dummy;     //dummy datatype used to align user-defined datatypes in memory
    double omega;           //relaxation factor - useless for Jacobi

    struct timeval tts,ttf,tcs,tcf;   //Timers: total-> tts,ttf, computation -> tcs,tcf
    double ttotal=0,tcomp=0,total_time,comp_time;

    double ** U, ** u_current, ** u_previous, ** swap; //Global matrix, local current and previous matrices, pointer to swap between current and previous


    MPI_Init(&argc,&argv);
    MPI_Comm_size(MPI_COMM_WORLD,&size);
    MPI_Comm_rank(MPI_COMM_WORLD,&rank);

    //----Read 2D-domain dimensions and process grid dimensions from stdin----//

    if (argc!=5) {
        fprintf(stderr,"Usage: mpirun .... ./exec X Y Px Py");
        exit(-1);
    }
    else {
        global[0]=atoi(argv[1]);
        global[1]=atoi(argv[2]);
        grid[0]=atoi(argv[3]);
        grid[1]=atoi(argv[4]);
    }

    //----Create 2D-cartesian communicator----//
    //----Usage of the cartesian communicator is optional----//

    MPI_Comm CART_COMM;         //CART_COMM: the new 2D-cartesian communicator
    int periods[2]={0,0};       //periods={0,0}: the 2D-grid is non-periodic
    int rank_grid[2];           //rank_grid: the position of each process on the new communicator

    /*  MPI_Cart_create - Makes a new communicator to which topology information has been attached

     *  comm_old    - input communicator (handle)
     *  ndims       - number of dimensions of cartesian grid (integer)
     *  dims        - integer array of size ndims specifying the number of processes in each dimension
     *  periods     - logical array of size ndims specifying whether the grid is periodic (true) or not (false) in each dimension
     *  reorder     - ranking may be reordered (true) or not (false) (logical)
     */
    MPI_Cart_create(MPI_COMM_WORLD,2,grid,periods,0,&CART_COMM);    //communicator creation
    
    
    /*  MPI_Cart_coords - Determines process coords in cartesian topology given rank in group
    
     *  comm    - communicator with cartesian structure (handle)
     *  rank    - rank of a process within group of comm (integer)
     *  maxdims - length of vector coords in the calling program (integer)
     */
    MPI_Cart_coords(CART_COMM,rank,2,rank_grid);	                //rank mapping on the new communicator

    //----Compute local 2D-subdomain dimensions----//
    //----Test if the 2D-domain can be equally distributed to all processes----//
    //----If not, pad 2D-domain----//
    
    for (i=0;i<2;i++) {
        if (global[i]%grid[i]==0) {
            local[i]=global[i]/grid[i];
            global_padded[i]=global[i];
        }
        else {
            local[i]=(global[i]/grid[i])+1;
            global_padded[i]=local[i]*grid[i];
        }
    }

	//Initialization of omega
    omega=2.0/(1+sin(3.14/global[0]));

    //----Allocate global 2D-domain and initialize boundary values----//
    //----Rank 0 holds the global 2D-domain----//
    if (rank==0) {
        free(U); //just for safety
        U=allocate2d(global_padded[0],global_padded[1]);   
        init2d(U,global[0],global[1]);
    }

    //----Allocate local 2D-subdomains u_current, u_previous----//
    //----Add a row/column on each size for ghost cells----//

    u_previous=allocate2d(local[0]+2,local[1]+2);
    u_current=allocate2d(local[0]+2,local[1]+2);   
       
    //----Distribute global 2D-domain from rank 0 to all processes----//
         
 	//----Appropriate datatypes are defined here----//
	/*****The usage of datatypes is optional*****/
    
    //----Datatype definition for the 2D-subdomain on the global matrix----//

    MPI_Datatype global_block;
    MPI_Type_vector(local[0],local[1],global_padded[1],MPI_DOUBLE,&dummy);
    MPI_Type_create_resized(dummy,0,sizeof(double),&global_block);
    MPI_Type_commit(&global_block);

    //----Datatype definition for the 2D-subdomain on the local matrix----//

    MPI_Datatype local_block;
    MPI_Type_vector(local[0],local[1],local[1]+2,MPI_DOUBLE,&dummy);
    MPI_Type_create_resized(dummy,0,sizeof(double),&local_block);
    MPI_Type_commit(&local_block);

    //----Rank 0 defines positions and counts of local blocks (2D-subdomains) on global matrix----//
    int * scatteroffset, * scattercounts;
    if (rank==0) {
        scatteroffset=(int*)malloc(size*sizeof(int));
        scattercounts=(int*)malloc(size*sizeof(int));
        for (i=0;i<grid[0];i++)
            for (j=0;j<grid[1];j++) {
                //count how many elements each proc gets
                scattercounts[i*grid[1]+j]=1;
                //count the offset of the elements that each proc gets
                scatteroffset[i*grid[1]+j]=(local[0]*local[1]*grid[1]*i+local[1]*j); 
            }
    }


    //----Rank 0 scatters the global matrix----//

    //----malloc the sendbuffer----//
    double * sendbuf = malloc(1);

    //----fill the buffer if only you are pid 0----//
    if (rank == 0) {
        free(sendbuf); //just for safety
        sendbuf = &U[0][0];
    }

    /*  MPI_Scatterv - Scatters a buffer in parts to all processes in a communicator
     *
     *  sendbuf     - address of send buffer (choice, significant only at root)
     *  sendcounts  - integer array (of length group size) specifying the number of elements to send to each processor
     *  displs      - integer array (of length group size). Entry i specifies the displacement (relative to sendbuf from which to take the outgoing data to process i
     *  sendtype    - data type of send buffer elements (handle)
     *  recvcount   - number of elements in receive buffer (integer)
     *  recvtype    - data type of receive buffer elements (handle)
     *  root        - rank of sending process (integer)
     *  comm        - communicator (handle)
     */
    MPI_Scatterv(sendbuf, scattercounts, scatteroffset, global_block, &u_current[1][1], 1, local_block, 0, MPI_COMM_WORLD);

    /*Make sure u_current and u_previous are both initialized*/

    // We use the init2d function from utils.c to initialize the variables
    init2d(u_previous, local[0]+2, local[1]+2);
    init2d(u_current, local[0]+2, local[1]+2);


    //************************************//


    if (rank==0)
        free2d(U);

    //----Define datatypes or allocate buffers for message passing----//

    // Documentation of why we use MPI_Type_create_resized 
    // https://www.mpich.org/static/docs/latest/www3/MPI_Type_create_resized.html
    // https://www.mpi-forum.org/docs/mpi-2.2/mpi22-report/node75.htm#Node75
    
    MPI_Datatype column;
    MPI_Type_vector(local[0]+2, 1, local[1]+2, MPI_DOUBLE, &dummy);
    MPI_Type_create_resized(dummy,0,sizeof(double),&column);
    MPI_Type_commit(&column);
    // MPI_Type_create_subarray ????

    //----Find the 4 neighbors with which a process exchanges messages----//

    int north, south, east, west;

	/*
	 * 
	 * THIS IS THE ONLY USE OF THE CARTESIAN COMMUNICATOR
     *
	 */

    /* MPI_Cart_shift - Returns the shifted source and destination ranks, given a shift direction and amount
     * int MPI_Cart_shift(MPI_Comm comm, int direction, int disp, int *rank_source, int *rank_dest)
     * comm - communicator with cartesian structure (handle)
     * direction - coordinate dimension of shift (integer)
     * disp - displacement (> 0: upwards shift, < 0: downwards shift) (integer)
     */

    MPI_Cart_shift(CART_COMM, 0, 1, &north, &south); // If -1 then neighbor doesn't exist
    MPI_Cart_shift(CART_COMM, 1, 1, &west, &east);	

	/*Make sure you handle non-existing neighbors appropriately*/

    //---Define the iteration ranges per process-----//

    /*Three types of ranges:
        - internal processes
        - boundary processes
        - boundary processes and padded global array
    */
    int i_min;
    int i_max;
    int j_min;
    int j_max;
    
    /* 
     * we will ask for MAX 8 cells to be sent to us
     * for each cell we need:
     * 1 request for send
     * 1 request for receiv
     * and we have 4 neighbours
     * if the neighbour cells are marginal then we will decrease the recv_req by 2
     */ 
    int number_of_requests = 8;
    
    i_min = 1;          //this is the min previous column you can check the temp
    i_max = local[0]+1; //this is the max next column you can check the temp
    j_min = 1;          //this is the min previous row you can check the temp
    j_max = local[1]+1; //this is the max next row you can check the temp

    //************************************//
    if (north < 0) {    //value is marginal
        number_of_requests -= 2;
        i_min++;
    }
    if (east < 0) {     //value is marginal
        number_of_requests -= 2;
        if (global_padded[1] == 1)
            j_max -= 2;
        else
            j_max --;
    }
    if (south < 0) {    //value is marginal
        number_of_requests -= 2;
        if (global_padded[0] == 1) //if temp filled here
            i_max -= 2;
        else
            i_max--;
    }
    if (west < 0) {     //value is marginal
        number_of_requests -= 2;
        j_min++;
    }

    int * converged_arr = malloc(sizeof(int));
    int * global_converged_arr = malloc(sizeof(int));


    double * northbuffer = ( double * )calloc( local[1] + 2, sizeof( double ) );
    double * southbuffer = ( double * )calloc( local[1] + 2, sizeof( double ) );
    double * westbuffer  = ( double * )calloc( local[0] + 2, sizeof( double ) );
    double * eastbuffer  = ( double * )calloc( local[0] + 2, sizeof( double ) );

    /* 
     * to establish a communication we should first open a request and a status.
     * it is like a "listening port" 
     * once the request is completed and status updated then the request closes.
     */
    MPI_Request * requests = (MPI_Request *) malloc(number_of_requests * sizeof(MPI_Request));
    MPI_Status * statuses = (MPI_Status *)malloc(number_of_requests * sizeof(MPI_Status));

    //----Computational core----//   
    gettimeofday(&tts, NULL);
    #ifdef TEST_CONV
    for (t=0;t<T && !global_converged;t++) {
    #endif
    #ifndef TEST_CONV
    #undef T
    #define T 256
    for (t=0;t<T;t++) {
    #endif

        /*Compute and Communicate*/
        
        // keep the latest values of the temperatures
        swap=u_previous;
        u_previous=u_current;
        u_current=swap;   
        
        number_of_requests = 0; //start counting requests

        gettimeofday(&tcs,NULL); //timers for prerformance

        Jacobi(u_previous,u_current,i_min,i_max,j_min,j_max); //check convergence

        gettimeofday(&tcf,NULL);
        tcomp+=(tcf.tv_sec-tcs.tv_sec)+(tcf.tv_usec-tcs.tv_usec)*0.000001;


        /*  
         *  every process does an asynchronous send and receive to save time 
         *  sends to and receives from the corresponding neighbour if he exists
         *  there is no need to send - wait - recv - wait, since asynchronous offers a better result
         *  we perform them together and use as a tag variable "t", depicting time step / generation
		 */

        // northbuffer : 1D array with size local[1]+2
        // southbuffer : 1D array with size local[1]+2
        // westbuffer  : 1D array with size local[0]+2
        // eastbuffer  : 1D array with size local[0]+2

        if (north >= 0) {
            MPI_Isend(&u_current[1][0]       , local[1] + 2, MPI_DOUBLE, north, t, MPI_COMM_WORLD, &requests[number_of_requests++]);
            MPI_Irecv(&northbuffer           , local[1] + 2, MPI_DOUBLE, north, t, MPI_COMM_WORLD, &requests[number_of_requests++]);
        }		
        if (south >= 0) {
            MPI_Isend(&u_current[local[0]][0], local[1] + 2, MPI_DOUBLE, south, t, MPI_COMM_WORLD, &requests[number_of_requests++]);
            MPI_Irecv(&southbuffer           , local[1] + 2, MPI_DOUBLE, south, t, MPI_COMM_WORLD, &requests[number_of_requests++]);
        }
        if (east >= 0) {
            MPI_Isend(&u_current[0][local[1]], 1, column, east, t, MPI_COMM_WORLD, &requests[number_of_requests++]);
            MPI_Irecv(&eastbuffer            , 1, column, east, t, MPI_COMM_WORLD, &requests[number_of_requests++]);
        }
        if (west >= 0) {
            MPI_Isend(&u_current[0][1]       , 1, column, west, t, MPI_COMM_WORLD, &requests[number_of_requests++]);
            MPI_Irecv(&westbuffer            , 1, column, west, t, MPI_COMM_WORLD, &requests[number_of_requests++]);
        }
        MPI_Waitall(number_of_requests, requests, statuses);


        #ifdef TEST_CONV
        if (t%C==0) {
            // Test convergence
            converged = converge(u_previous, u_current, i_max, j_max);
            // store result /*DISCLAIMER: converged_arr is an array of 1 element*/
            converged_arr[0] = converged;
            // gather all converged together on root
            MPI_Reduce(&converged_arr[0], &global_converged_arr[0], 1, MPI_INT, MPI_PROD, 0, MPI_COMM_WORLD);
            MPI_Bcast(&global_converged_arr[0], 1, MPI_INT, 0, MPI_COMM_WORLD);
            // set local loop variable
            global_converged = global_converged_arr[0];
        }		
        #endif         
        
    }
    gettimeofday(&ttf,NULL);

    ttotal=(ttf.tv_sec-tts.tv_sec)+(ttf.tv_usec-tts.tv_usec)*0.000001;

    MPI_Reduce(&ttotal,&total_time,1,MPI_DOUBLE,MPI_MAX,0,MPI_COMM_WORLD);
    MPI_Reduce(&tcomp,&comp_time,1,MPI_DOUBLE,MPI_MAX,0,MPI_COMM_WORLD);


    //----Rank 0 gathers local matrices back to the global matrix----//

    if (rank==0) {
        U=allocate2d(global_padded[0],global_padded[1]);
        sendbuf = &U[0][0]; //its actually the recvbuff for the next collective operation: MPI_Gatherv
    }

    /*
     * EVERYONE performs this operation
     * only the specified as root proc gathers the data
     * everyone else sends the sendbuf
     */
    MPI_Gatherv(&u_current[1][1]    // send buffer (id != 0)
                ,1                  // number of elements in send buffer (id != 0) 
                ,local_block        // data type (id != 0)
                ,sendbuf            // receive buffer (id == 0)
                ,scattercounts      // number of elements in receive buffer (id == 0)
                ,scatteroffset      // offset for everyproc (id != 0)
                ,global_block       // receive datatype (id == 0)
                ,0                  // root proc id (id == 0)
                ,MPI_COMM_WORLD     // communicator
                );

    //----Printing results----//

    //**************TODO: Change "Jacobi" to "GaussSeidelSOR" or "RedBlackSOR" for appropriate printing****************//
    if (rank==0) {
        printf("Jacobi X %d Y %d Px %d Py %d Iter %d ComputationTime %lf TotalTime %lf midpoint %lf\n",global[0],global[1],grid[0],grid[1],t,comp_time,total_time,U[global[0]/2][global[1]/2]);
	
        #ifdef PRINT_RESULTS
        char * s=malloc(50*sizeof(char));
        sprintf(s,"resJacobiMPI_%dx%d_%dx%d",global[0],global[1],grid[0],grid[1]);
        fprint2d(s,U,global[0],global[1]);
        free(s);
        #endif

    }
    MPI_Finalize();
    return 0;
}

void Jacobi(double ** u_previous, double ** u_current, int X_min, int X_max, int Y_min, int Y_max) {
    int i,j;
    for (i=X_min;i<X_max;i++)
        for (j=Y_min;j<Y_max;j++)
            u_current[i][j]=(u_previous[i-1][j]+u_previous[i+1][j]+u_previous[i][j-1]+u_previous[i][j+1])/4.0;
}
