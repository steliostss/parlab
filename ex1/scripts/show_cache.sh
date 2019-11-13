#!/bin/bash

## Give the Job a descriptive name
#PBS -N run_omp_game_of_life

## Output and error files
#PBS -o /home/parallel/parlab30/a1/out/cache.out
#PBS -e /home/parallel/parlab30/a1/err/cache.err

## How many machines should we get? 
#PBS -l nodes=1:ppn=4

##How long should the job run for?
#PBS -l walltime=00:10:00

## Start 
## Run make in the src folder (modify properly)

module load openmp

for d in /sys/devices/system/cpu/cpu0/cache/index*;
  do tail -c+1 $d/{level,type,size}
done
