#!/bin/bash

## Give the Job a descriptive name
#PBS -N test_correctness_mpi

## Output and error files
#PBS -o test_correctness_mpi.out
#PBS -e test_correctness_mpi.err

## Limit memory, runtime etc.

## How many nodes:processors_per_node should we get?
## Run on parlab
#PBS -l nodes=4:ppn=8

## Start 
##echo "PBS_NODEFILE = $PBS_NODEFILE"
##cat $PBS_NODEFILE

## Run the job (use full paths to make sure we execute the correct thing)

MPIFLAGS="--map-by node --mca btl tcp,self --mca shmem_mmap_enable_nfs_warning 0"

## NOTE: Fix the path to show to your serial executables 

module load openmpi/1.8.3
cd /home/parallel/parlab30/a2/serial/

for execfile in  jacobi seidelsor
do
	./${execfile} 256 256
done


## NOTE: Fix the path to show to your MPI executables
cd /home/parallel/parlab30/a2/mpi/

for execfile in jacobi_mpi_conv gauss_seidel_mpi_conv  
do
	mpirun -np 32 ${MPIFLAGS} ${execfile} 256 256 8 4
done

## Make sure you enable convergence testing and printing
