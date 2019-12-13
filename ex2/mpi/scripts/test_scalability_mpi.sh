#!/bin/bash

## Give the Job a descriptive name
#PBS -N test_scalability_mpi

## Output and error files
#PBS -o test_scalability_mpi.out
#PBS -e test_scalability_mpi.err

## Limit memory, runtime etc.

## How many nodes:processors_per_node should we get?
## Run on parlab
#PBS -l nodes=4:ppn=8

## Start 
##echo "PBS_NODEFILE = $PBS_NODEFILE"
##cat $PBS_NODEFILE

## Run the job (use full paths to make sure we execute the correct thing) 
## NOTE: Fix the path to show to your executable! 

module load openmpi/1.8.3
cd /home/parallel/parlab30/a2/mpi/

MPIFLAGS="--map-by node --mca btl tcp,self --mca shmem_mmap_enable_nfs_warning 0"

## NOTE: Fix the names of your executables

for size in 1024 2000
do
	for execfile in jacobi_mpi_NO_conv gauss_seidel_mpi_NO_conv  red_black_mpi_NO_conv
	do
		mpirun -np 1 ${MPIFLAGS} ${execfile} ${size} ${size} 1 1 >>ScalabilityResultsMPI_${execfile}_${size}
		mpirun -np 2 ${MPIFLAGS} ${execfile} ${size} ${size} 2 1 >>ScalabilityResultsMPI_${execfile}_${size}
		mpirun -np 4 ${MPIFLAGS} ${execfile} ${size} ${size} 2 2 >>ScalabilityResultsMPI_${execfile}_${size}
		mpirun -np 8 ${MPIFLAGS} ${execfile} ${size} ${size} 4 2 >>ScalabilityResultsMPI_${execfile}_${size}
		mpirun -np 16 ${MPIFLAGS} ${execfile} ${size} ${size} 4 4 >>ScalabilityResultsMPI_${execfile}_${size}
		mpirun -np 32 ${MPIFLAGS} ${execfile} ${size} ${size} 8 4 >>ScalabilityResultsMPI_${execfile}_${size}
	done
done

## Make sure you disable convergence testing and printing
