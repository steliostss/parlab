#!/bin/bash

## Give the Job a descriptive name
#PBS -N get_GPU_details

## Output and error files
#PBS -o get_GPU_details.out
#PBS -e get_GPU_details.err

## How many machines should we get?
#PBS -l nodes=dungani:ppn=1

##How long should the job run for?
#PBS -l walltime=00:10:00

## Start
cd /home/parallel/parlab30/a4/

make query

