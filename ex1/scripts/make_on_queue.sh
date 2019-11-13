#!/bin/bash

## Give the Job a descriptive name
#PBS -N make_omp_game_of_life

## Output and error files
#PBS -o /home/parallel/parlab30/a1/out/Make_game.out
#PBS -e /home/parallel/parlab30/a1/err/Make_game.err

## How many machines should we get? 
#PBS -l nodes=1:ppn=1

##How long should the job run for?
#PBS -l walltime=00:10:00

## Start 
## Run make in the src folder (modify properly)

module load openmp
cd /home/parallel/parlab30/a1/
make

