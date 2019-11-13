#!/bin/bash

## Give the Job a descriptive name
#PBS -N run_omp_game_of_life

## Output and error files
#PBS -o /home/parallel/parlab30/a1/out/Run_game.out
#PBS -e /home/parallel/parlab30/a1/err/Run_game.err

## How many machines should we get? 
#PBS -l nodes=1:ppn=4

##How long should the job run for?
#PBS -l walltime=00:10:00

## Start 
## Run make in the src folder (modify properly)

module load openmp
cd /home/parallel/parlab30/a1/exec
export OMP_NUM_THREADS=4
##./parallel 64 1000
##./parallel 1024 1000
##./parallel 4096 1000
#echo
./serial 64 1000
./serial 1024 1000
./serial 4096 1000
echo
