#!/bin/bash

## Give the Job a descriptive name
#PBS -N run_serial

## Output and error files
#PBS -o run_serial.out
#PBS -e run_serial.err

## Limit memory, runtime etc.
#PBS -l walltime=05:00:00

## How many machines should we get?
#PBS -l nodes=1:ppn=1

## Start
##echo "PBS_NODEFILE = $PBS_NODEFILE"
##cat $PBS_NODEFILE

module load openmpi/1.8.3
cd /home/parallel/parlab30/a2/serial/

## jacobi seidelsor redblacksor jacobi_NO_conv seidelsor_NO_conv redblacksor_NO_conv

echo "With convergence"
./jacobi 1024
./seidelsor 1024
./redblacksor 1024

echo "Without convergence"
./jacobi_NO_conv 1024
./jacobi_NO_conv 2048
./jacobi_NO_conv 4096
./jacobi_NO_conv 6144
./seidelsor_NO_conv 1024
./seidelsor_NO_conv 2048
./seidelsor_NO_conv 4096
./seidelsor_NO_conv 6144
./redblacksor_NO_conv 1024
./redblacksor_NO_conv 2048
./redblacksor_NO_conv 4096
./redblacksor_NO_conv 6144
