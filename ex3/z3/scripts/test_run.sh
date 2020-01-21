#!/bin/bash

## Give the Job a descriptive name
#PBS -N make_locks_z3

## Output and error files
#PBS -o make_locks_z3.out
#PBS -e make_locks_z3.err

## How many machines should we get?
#PBS -l nodes=sandman:ppn=64

##How long should the job run for?
#PBS -l walltime=00:10:00

## Start
## Run make in the src folder (modify properly)

cd /home/parallel/parlab30/a3/z3/

echo "Nthreads, Throughput(Kops/sec), Runtime(sec), Workload, MT_CONF"

echo "serial 1024 80 10 10"
MT_CONF=0 ./serial 1024 80 10 10

echo "fgl 1024 80 10 10"
MT_CONF=0 ./fgl 1024 80 10 10

echo "fgl 8192 20 40 40"
MT_CONF=0 ./fgl 8192 20 40 40 

echo "opt 1024 80 10 10"
MT_CONF=0 ./opt 1024 80 10 10

echo "opt 8192 20 40 40"
MT_CONF=0 ./opt 8192 20 40 40 

echo "lazy 8192 80 10 10"
MT_CONF=0 ./lazy 8192 80 10 10 

echo "lazy 1024 20 40 40"
MT_CONF=0 ./lazy 1024 20 40 40

echo "nb 1024 80 10 10"
MT_CONF=0 ./nb 1024 80 10 10

echo "nb 8192 20 40 40"
MT_CONF=0 ./nb 8192 20 40 40
