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

MPIFLAGS="--map-by node --mca btl tcp,self --mca shmem_mmap_enable_nfs_warning 0"

echo "-------------------------------------------------------------------------------------------------------------------------------------"
echo "--------------------------------------------------JACOBI-----------------------------------------------------------------------------"
echo "-------------------------------------------------------------------------------------------------------------------------------------"
echo
echo

echo "*********************WITH CONVERGENCE**************************"
mpirun $MPIFLAGS -np 64 ./jacobi_mpi_conv 1024 1024 8 8
mpirun $MPIFLAGS -np 64 ./jacobi_mpi_conv 1024 1024 4 16
mpirun $MPIFLAGS -np 64 ./jacobi_mpi_conv 1024 1024 2 32
echo
echo

echo "*********************WITHOUT CONVERGENCE**************************"

mpirun $MPIFLAGS -np 1 ./jacobi_mpi_NO_conv 2048 2048 1 1
mpirun $MPIFLAGS -np 2 ./jacobi_mpi_NO_conv 2048 2048 1 2
mpirun $MPIFLAGS -np 4 ./jacobi_mpi_NO_conv 2048 2048 2 2
mpirun $MPIFLAGS -np 8 ./jacobi_mpi_NO_conv 2048 2048 2 4
mpirun $MPIFLAGS -np 16 ./jacobi_mpi_NO_conv 2048 2048 4 4
mpirun $MPIFLAGS -np 32 ./jacobi_mpi_NO_conv 2048 2048 4 8
mpirun $MPIFLAGS -np 64 ./jacobi_mpi_NO_conv 2048 2048 8 8

mpirun $MPIFLAGS -np 1 ./jacobi_mpi_NO_conv 4096 4096 1 1
mpirun $MPIFLAGS -np 2 ./jacobi_mpi_NO_conv 4096 4096 1 2
mpirun $MPIFLAGS -np 4 ./jacobi_mpi_NO_conv 4096 4096 2 2
mpirun $MPIFLAGS -np 8 ./jacobi_mpi_NO_conv 4096 4096 2 4
mpirun $MPIFLAGS -np 16 ./jacobi_mpi_NO_conv 4096 4096 4 4
mpirun $MPIFLAGS -np 32 ./jacobi_mpi_NO_conv 4096 4096 4 8
mpirun $MPIFLAGS -np 64 ./jacobi_mpi_NO_conv 4096 4096 8 8

mpirun $MPIFLAGS -np 1 ./jacobi_mpi_NO_conv 6144 6144 1 1
mpirun $MPIFLAGS -np 2 ./jacobi_mpi_NO_conv 6144 6144 1 2
mpirun $MPIFLAGS -np 4 ./jacobi_mpi_NO_conv 6144 6144 2 2
mpirun $MPIFLAGS -np 8 ./jacobi_mpi_NO_conv 6144 6144 2 4
mpirun $MPIFLAGS -np 16 ./jacobi_mpi_NO_conv 6144 6144 4 4
mpirun $MPIFLAGS -np 32 ./jacobi_mpi_NO_conv 6144 6144 4 8
mpirun $MPIFLAGS -np 64 ./jacobi_mpi_NO_conv 6144 6144 8 8

echo
echo
echo "-------------------------------------------------------------------------------------------------------------------------------------"
echo "--------------------------------------------------GAUSS-SEIDEL-----------------------------------------------------------------------"
echo "-------------------------------------------------------------------------------------------------------------------------------------"
echo
echo

echo "*********************WITH CONVERGENCE**************************"
mpirun $MPIFLAGS -np 64 ./gauss_seidel_mpi_conv 1024 1024 8 8 
mpirun $MPIFLAGS -np 64 ./gauss_seidel_mpi_conv 1024 1024 4 16 
mpirun $MPIFLAGS -np 64 ./gauss_seidel_mpi_conv 1024 1024 2 32

mpirun $MPINODEFLAGS -np 1 ./gauss_seidel_mpi_NO_conv 2048 2048 1 1
mpirun $MPINODEFLAGS -np 2 ./gauss_seidel_mpi_NO_conv 2048 2048 1 2
mpirun $MPINODEFLAGS -np 4 ./gauss_seidel_mpi_NO_conv 2048 2048 2 2
mpirun $MPINODEFLAGS -np 8 ./gauss_seidel_mpi_NO_conv 2048 2048 2 4
mpirun $MPINODEFLAGS -np 16 ./gauss_seidel_mpi_NO_conv 2048 2048 4 4
mpirun $MPINODEFLAGS -np 32 ./gauss_seidel_mpi_NO_conv 2048 2048 4 8
mpirun $MPINODEFLAGS -np 64 ./gauss_seidel_mpi_NO_conv 2048 2048 8 8

mpirun $MPINODEFLAGS -np 1 ./gauss_seidel_mpi_NO_conv 4096 4096 1 1
mpirun $MPINODEFLAGS -np 2 ./gauss_seidel_mpi_NO_conv 4096 4096 1 2
mpirun $MPINODEFLAGS -np 4 ./gauss_seidel_mpi_NO_conv 4096 4096 2 2
mpirun $MPINODEFLAGS -np 8 ./gauss_seidel_mpi_NO_conv 4096 4096 2 4
mpirun $MPINODEFLAGS -np 16 ./gauss_seidel_mpi_NO_conv 4096 4096 4 4
mpirun $MPINODEFLAGS -np 32 ./gauss_seidel_mpi_NO_conv 4096 4096 4 8
mpirun $MPINODEFLAGS -np 64 ./gauss_seidel_mpi_NO_conv 4096 4096 8 8

mpirun $MPINODEFLAGS -np 1 ./gauss_seidel_mpi_NO_conv 6144 6144 1 1
mpirun $MPINODEFLAGS -np 2 ./gauss_seidel_mpi_NO_conv 6144 6144 1 2
mpirun $MPINODEFLAGS -np 4 ./gauss_seidel_mpi_NO_conv 6144 6144 2 2
mpirun $MPINODEFLAGS -np 8 ./gauss_seidel_mpi_NO_conv 6144 6144 2 4
mpirun $MPIFLAGS -np 16 ./gauss_seidel_mpi_NO_conv 6144 6144 4 4
mpirun $MPIFLAGS -np 32 ./gauss_seidel_mpi_NO_conv 6144 6144 4 8
mpirun $MPIFLAGS -np 64 ./gauss_seidel_mpi_NO_conv 6144 6144 8 8

echo
echo
echo "-------------------------------------------------------------------------------------------------------------------------------------"
echo "--------------------------------------------------RED_BLACK_SOR----------------------------------------------------------------------"
echo "-------------------------------------------------------------------------------------------------------------------------------------"
echo
echo


echo "*********************WITH CONVERGENCE**************************"
mpirun $MPIFLAGS -np 64 ./red_black_mpi_conv 1024 1024 8 8 
mpirun $MPIFLAGS -np 64 ./red_black_mpi_conv 1024 1024 4 16 
mpirun $MPIFLAGS -np 64 ./red_black_mpi_conv 1024 1024 2 32
echo
echo

echo "*********************WITHOUT CONVERGENCE**************************"
mpirun $MPIFLAGS -np 1 ./red_black_mpi_NO_conv 2048 2048 1 1
mpirun $MPIFLAGS -np 2 ./red_black_mpi_NO_conv 2048 2048 1 2
mpirun $MPIFLAGS -np 4 ./red_black_mpi_NO_conv 2048 2048 2 2
mpirun $MPIFLAGS -np 8 ./red_black_mpi_NO_conv 2048 2048 2 4
mpirun $MPIFLAGS -np 16 ./red_black_mpi_NO_conv 2048 2048 4 4
mpirun $MPIFLAGS -np 32 ./red_black_mpi_NO_conv 2048 2048 4 8
mpirun $MPIFLAGS -np 64 ./red_black_mpi_NO_conv 2048 2048 8 8

mpirun $MPIFLAGS -np 1 ./red_black_mpi_NO_conv 4096 4096 1 1
mpirun $MPIFLAGS -np 2 ./red_black_mpi_NO_conv 4096 4096 1 2
mpirun $MPIFLAGS -np 4 ./red_black_mpi_NO_conv 4096 4096 2 2
mpirun $MPIFLAGS -np 8 ./red_black_mpi_NO_conv 4096 4096 2 4
mpirun $MPIFLAGS -np 16 ./red_black_mpi_NO_conv 4096 4096 4 4
mpirun $MPIFLAGS -np 32 ./red_black_mpi_NO_conv 4096 4096 4 8
mpirun $MPIFLAGS -np 64 ./red_black_mpi_NO_conv 4096 4096 8 8

mpirun $MPIFLAGS -np 1 ./red_black_mpi_NO_conv 6144 6144 1 1
mpirun $MPIFLAGS -np 2 ./red_black_mpi_NO_conv 6144 6144 1 2
mpirun $MPIFLAGS -np 4 ./red_black_mpi_NO_conv 6144 6144 2 2
mpirun $MPIFLAGS -np 8 ./red_black_mpi_NO_conv 6144 6144 2 4
mpirun $MPIFLAGS -np 16 ./red_black_mpi_NO_conv 6144 6144 4 4
mpirun $MPIFLAGS -np 32 ./red_black_mpi_NO_conv 6144 6144 4 8
mpirun $MPIFLAGS -np 64 ./red_black_mpi_NO_conv 6144 6144 8 8
