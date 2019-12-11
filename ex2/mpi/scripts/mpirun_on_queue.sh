#!/bin/bash

## Give the Job a descriptive name
#PBS -N run_mpi_test_jacobi

## Output and error files
#PBS -o run_mpi_test_jacobi.out
#PBS -e run_mpi_test_jacobi.err

## Limit memory, runtime etc.
#PBS -l walltime=05:00:00

## How many machines should we get?
#PBS -l nodes=8:ppn=8

## Start 
##echo "PBS_NODEFILE = $PBS_NODEFILE"
##cat $PBS_NODEFILE

module load openmpi/1.8.3
cd /home/parallel/parlab30/a2/mpi/

echo "-------------------------------------------------------------------------------------------------------------------------------------"
echo "--------------------------------------------------JACOBI-----------------------------------------------------------------------------"
echo "-------------------------------------------------------------------------------------------------------------------------------------"


echo "*********************WITH CONVERGENCE**************************"
echo "Jabobi Procs 64 Grid 8X8 Array 1024"
mpirun -np 64 --map-by node --mca btl tcp,self --mca shmem_mmap_enable_nfs_warning 0 ./jacobi_mpi_conv 1024 1024 8 8
echo

echo "Jacobi Procs 64 Grid 4X16 Array 1024"
mpirun -np 64 --map-by node --mca btl tcp,self --mca shmem_mmap_enable_nfs_warning 0 ./jacobi_mpi_conv 1024 1024 4 16
echo

echo "Jacobi Procs 64 Grid 2X32 Array 1024"
mpirun -np 64 --map-by node --mca btl tcp,self --mca shmem_mmap_enable_nfs_warning 0 ./jacobi_mpi_conv 1024 1024 2 32
echo

echo "*********************WITHOUT CONVERGENCE**************************"
echo "Jacobi Procs 1 Array 2048"
mpirun -np 1 --map-by node --mca btl tcp,self --mca shmem_mmap_enable_nfs_warning 0 ./jacobi_mpi_NO_conv 2048 2048 1 1
echo "Jacobi Procs 2 Array 2048"
mpirun -np 2 --map-by node --mca btl tcp,self --mca shmem_mmap_enable_nfs_warning 0 ./jacobi_mpi_NO_conv 2048 2048 1 2
echo "Jacobi Procs 4 Array 2048"
mpirun -np 4 --map-by node --mca btl tcp,self --mca shmem_mmap_enable_nfs_warning 0 ./jacobi_mpi_NO_conv 2048 2048 2 2
echo "Jacobi Procs 8 Array 2048"
mpirun -np 8 --map-by node --mca btl tcp,self --mca shmem_mmap_enable_nfs_warning 0 ./jacobi_mpi_NO_conv 2048 2048 2 4
echo "Jacobi Procs 16 Array 2048"
mpirun -np 16 --map-by node --mca btl tcp,self --mca shmem_mmap_enable_nfs_warning 0 ./jacobi_mpi_NO_conv 2048 2048 4 4
echo "Jacobi Procs 32 Array 2048"
mpirun -np 32 --map-by node --mca btl tcp,self --mca shmem_mmap_enable_nfs_warning 0 ./jacobi_mpi_NO_conv 2048 2048 4 8
echo "Jacobi Procs 64 Array 2048"
mpirun -np 64 --map-by node --mca btl tcp,self --mca shmem_mmap_enable_nfs_warning 0 ./jacobi_mpi_NO_conv 2048 2048 8 8

echo "Jacobi Procs 1 Array 4096"
mpirun -np 1 --map-by node --mca btl tcp,self --mca shmem_mmap_enable_nfs_warning 0 ./jacobi_mpi_NO_conv 4096 4096 1 1
echo "Jacobi Procs 2 Array 4096"
mpirun -np 2 --map-by node --mca btl tcp,self --mca shmem_mmap_enable_nfs_warning 0 ./jacobi_mpi_NO_conv 4096 4096 1 2
echo "Jacobi Procs 4 Array 4096"
mpirun -np 4 --map-by node --mca btl tcp,self --mca shmem_mmap_enable_nfs_warning 0 ./jacobi_mpi_NO_conv 4096 4096 2 2
echo "Jacobi Procs 8 Array 4096"
mpirun -np 8 --map-by node --mca btl tcp,self --mca shmem_mmap_enable_nfs_warning 0 ./jacobi_mpi_NO_conv 4096 4096 2 4
echo "Jacobi Procs 16 Array 4096"
mpirun -np 16 --map-by node --mca btl tcp,self --mca shmem_mmap_enable_nfs_warning 0 ./jacobi_mpi_NO_conv 4096 4096 4 4
echo "Jacobi Procs 32 Array 4096"
mpirun -np 32 --map-by node --mca btl tcp,self --mca shmem_mmap_enable_nfs_warning 0 ./jacobi_mpi_NO_conv 4096 4096 4 8
echo "Jacobi Procs 64 Array 4096"
mpirun -np 64 --map-by node --mca btl tcp,self --mca shmem_mmap_enable_nfs_warning 0 ./jacobi_mpi_NO_conv 4096 4096 8 8

echo "Jacobi Procs 1 Array 6144"
mpirun -np 1 --map-by node --mca btl tcp,self --mca shmem_mmap_enable_nfs_warning 0 ./jacobi_mpi_NO_conv 6144 6144 1 1
echo "Jacobi Procs 2 Array 6144"
mpirun -np 2 --map-by node --mca btl tcp,self --mca shmem_mmap_enable_nfs_warning 0 ./jacobi_mpi_NO_conv 6144 6144 1 2
echo "Jacobi Procs 4 Array 6144"
mpirun -np 4 --map-by node --mca btl tcp,self --mca shmem_mmap_enable_nfs_warning 0 ./jacobi_mpi_NO_conv 6144 6144 2 2
echo "Jacobi Procs 8 Array 6144"
mpirun -np 8 --map-by node --mca btl tcp,self --mca shmem_mmap_enable_nfs_warning 0 ./jacobi_mpi_NO_conv 6144 6144 2 4
echo "Jacobi Procs 16 Array 6144"
mpirun -np 16 --map-by node --mca btl tcp,self --mca shmem_mmap_enable_nfs_warning 0 ./jacobi_mpi_NO_conv 6144 6144 4 4
echo "Jacobi Procs 32 Array 6144"
mpirun -np 32 --map-by node --mca btl tcp,self --mca shmem_mmap_enable_nfs_warning 0 ./jacobi_mpi_NO_conv 6144 6144 4 8
echo "Jacobi Procs 64 Array 6144"
mpirun -np 64 --map-by node --mca btl tcp,self --mca shmem_mmap_enable_nfs_warning 0 ./jacobi_mpi_NO_conv 6144 6144 8 8


echo "-------------------------------------------------------------------------------------------------------------------------------------"
echo "--------------------------------------------------GAUSS-SEIDEL-----------------------------------------------------------------------"
echo "-------------------------------------------------------------------------------------------------------------------------------------"


echo "*********************WITH CONVERGENCE**************************"
echo "Gauss-Seidel Procs 64 Grid 8X8 Array 1024"
mpirun -np 64 --mca shmem_mmap_enable_nfs_warning 0 ./gauss_seidel_mpi_conv 1024 1024 8 8 
echo

echo "Gauss-Seidel Procs 64 Grid 4X16 Array 1024"
mpirun -np 64 --mca shmem_mmap_enable_nfs_warning 0 ./gauss_seidel_mpi_conv 1024 1024 4 16 
echo

echo "Gauss-Seidel Procs 64 Grid 2X32 Array 1024"
mpirun -np 64 --mca shmem_mmap_enable_nfs_warning 0 ./gauss_seidel_mpi_conv 1024 1024 2 32
echo

echo "*********************WITHOUT CONVERGENCE**************************"
echo "Gauss-Seidel Procs 1 Array 2048"
mpirun -np 1 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./gauss_seidel_mpi_NO_conv 2048 2048 1 1
echo "Gauss-Seidel Procs 2 Array 2048"
mpirun -np 2 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./gauss_seidel_mpi_NO_conv 2048 2048 1 2
echo "Gauss-Seidel Procs 4 Array 2048"
mpirun -np 4 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./gauss_seidel_mpi_NO_conv 2048 2048 2 2
echo "Gauss-Seidel Procs 8 Array 2048"
mpirun -np 8 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./gauss_seidel_mpi_NO_conv 2048 2048 2 4
echo "Gauss-Seidel Procs 16 Array 2048"
mpirun -np 16 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./gauss_seidel_mpi_NO_conv 2048 2048 4 4
echo "Gauss-Seidel Procs 32 Array 2048"
mpirun -np 32 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./gauss_seidel_mpi_NO_conv 2048 2048 4 8
echo "Gauss-Seidel Procs 64 Array 2048"
mpirun -np 64 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./gauss_seidel_mpi_NO_conv 2048 2048 8 8

echo "Gauss-Seidel Procs 1 Array 4096"
mpirun -np 1 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./gauss_seidel_mpi_NO_conv 4096 4096 1 1
echo "Gauss-Seidel Procs 2 Array 4096"
mpirun -np 2 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./gauss_seidel_mpi_NO_conv 4096 4096 1 2
echo "Gauss-Seidel Procs 4 Array 4096"
mpirun -np 4 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./gauss_seidel_mpi_NO_conv 4096 4096 2 2
echo "Gauss-Seidel Procs 8 Array 4096"
mpirun -np 8 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./gauss_seidel_mpi_NO_conv 4096 4096 2 4
echo "Gauss-Seidel Procs 16 Array 4096"
mpirun -np 16 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./gauss_seidel_mpi_NO_conv 4096 4096 4 4
echo "Gauss-Seidel Procs 32 Array 4096"
mpirun -np 32 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./gauss_seidel_mpi_NO_conv 4096 4096 4 8
echo "Gauss-Seidel Procs 64 Array 4096"
mpirun -np 64 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./gauss_seidel_mpi_NO_conv 4096 4096 8 8

echo "Gauss-Seidel Procs 1 Array 6144"
mpirun -np 1 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./gauss_seidel_mpi_NO_conv 6144 6144 1 1
echo "Gauss-Seidel Procs 2 Array 6144"
mpirun -np 2 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./gauss_seidel_mpi_NO_conv 6144 6144 1 2
echo "Gauss-Seidel Procs 4 Array 6144"
mpirun -np 4 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./gauss_seidel_mpi_NO_conv 6144 6144 2 2
echo "Gauss-Seidel Procs 8 Array 6144"
mpirun -np 8 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./gauss_seidel_mpi_NO_conv 6144 6144 2 4
echo "Gauss-Seidel Procs 16 Array 6144"
mpirun -np 16 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./gauss_seidel_mpi_NO_conv 6144 6144 4 4
echo "Gauss-Seidel Procs 32 Array 6144"
mpirun -np 32 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./gauss_seidel_mpi_NO_conv 6144 6144 4 8
echo "Gauss-Seidel Procs 64 Array 6144"
mpirun -np 64 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./gauss_seidel_mpi_NO_conv 6144 6144 8 8


echo "-------------------------------------------------------------------------------------------------------------------------------------"
echo "--------------------------------------------------RED_BLACK_SOR----------------------------------------------------------------------"
echo "-------------------------------------------------------------------------------------------------------------------------------------"



echo "*********************WITH CONVERGENCE**************************"
echo "Red-Black-SOR Procs 64 Grid 8X8 Array 1024"
mpirun -np 64 --mca shmem_mmap_enable_nfs_warning 0 ./red_black_mpi_conv 1024 1024 8 8 
echo

echo "Red-Black-SOR Procs 64 Grid 4X16 Array 1024"
mpirun -np 64 --mca shmem_mmap_enable_nfs_warning 0 ./red_black_mpi_conv 1024 1024 4 16 
echo

echo "Red-Black-SOR Procs 64 Grid 2X32 Array 1024"
mpirun -np 64 --mca shmem_mmap_enable_nfs_warning 0 ./red_black_mpi_conv 1024 1024 2 32
echo

echo "*********************WITHOUT CONVERGENCE**************************"
echo "Red-Black-SOR Procs 1 Array 2048"
mpirun -np 1 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./red_black_mpi_NO_conv 2048 2048 1 1
echo "Red-Black-SOR Procs 2 Array 2048"
mpirun -np 2 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./red_black_mpi_NO_conv 2048 2048 1 2
echo "Red-Black-SOR Procs 4 Array 2048"
mpirun -np 4 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./red_black_mpi_NO_conv 2048 2048 2 2
echo "Red-Black-SOR Procs 8 Array 2048"
mpirun -np 8 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./red_black_mpi_NO_conv 2048 2048 2 4
echo "Red-Black-SOR Procs 16 Array 2048"
mpirun -np 16 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./red_black_mpi_NO_conv 2048 2048 4 4
echo "Red-Black-SOR Procs 32 Array 2048"
mpirun -np 32 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./red_black_mpi_NO_conv 2048 2048 4 8
echo "Red-Black-SOR Procs 64 Array 2048"
mpirun -np 64 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./red_black_mpi_NO_conv 2048 2048 8 8

echo "Red-Black-SOR Procs 1 Array 4096"
mpirun -np 1 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./red_black_mpi_NO_conv 4096 4096 1 1
echo "Red-Black-SOR Procs 2 Array 4096"
mpirun -np 2 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./red_black_mpi_NO_conv 4096 4096 1 2
echo "Red-Black-SOR Procs 4 Array 4096"
mpirun -np 4 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./red_black_mpi_NO_conv 4096 4096 2 2
echo "Red-Black-SOR Procs 8 Array 4096"
mpirun -np 8 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./red_black_mpi_NO_conv 4096 4096 2 4
echo "Red-Black-SOR Procs 16 Array 4096"
mpirun -np 16 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./red_black_mpi_NO_conv 4096 4096 4 4
echo "Red-Black-SOR Procs 32 Array 4096"
mpirun -np 32 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./red_black_mpi_NO_conv 4096 4096 4 8
echo "Red-Black-SOR Procs 64 Array 4096"
mpirun -np 64 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./red_black_mpi_NO_conv 4096 4096 8 8

echo "Red-Black-SOR Procs 1 Array 6144"
mpirun -np 1 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./red_black_mpi_NO_conv 6144 6144 1 1
echo "Red-Black-SOR Procs 2 Array 6144"
mpirun -np 2 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./red_black_mpi_NO_conv 6144 6144 1 2
echo "Red-Black-SOR Procs 4 Array 6144"
mpirun -np 4 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./red_black_mpi_NO_conv 6144 6144 2 2
echo "Red-Black-SOR Procs 8 Array 6144"
mpirun -np 8 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./red_black_mpi_NO_conv 6144 6144 2 4
echo "Red-Black-SOR Procs 16 Array 6144"
mpirun -np 16 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./red_black_mpi_NO_conv 6144 6144 4 4
echo "Red-Black-SOR Procs 32 Array 6144"
mpirun -np 32 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./red_black_mpi_NO_conv 6144 6144 4 8
echo "Red-Black-SOR Procs 64 Array 6144"
mpirun -np 64 --map-by node --mca btl tcp,self shmem_mmap_enable_nfs_warning 0 ./red_black_mpi_NO_conv 6144 6144 8 8
