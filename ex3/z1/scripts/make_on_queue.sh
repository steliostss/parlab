#!/bin/bash

## Give the Job a descriptive name
#PBS -N make_accounts

## Output and error files
#PBS -o mpi/make_accounts.out
#PBS -e mpi/make_accounts.err

## How many machines should we get?
#PBS -l nodes=1:ppn=1

##How long should the job run for?
#PBS -l walltime=00:10:00

## Start
## Run make in the src folder (modify properly)

cd /home/parallel/parlab30/a3/z1/
make

