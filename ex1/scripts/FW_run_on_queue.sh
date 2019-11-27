#!/bin/bash

## Give the Job a descriptive name
#PBS -N run_omp_fw_sec

## Output and error files
#PBS -o /home/parallel/parlab30/a1/out/Run_FW.out
#PBS -e /home/parallel/parlab30/a1/err/Run_FW.err

## How many machines should we get? 
#PBS -l nodes=sandman:ppn=64

##How long should the job run for?
#PBS -l walltime=10:00:00

## Start 
## Run make in the src folder (modify properly)

module load openmp
cd /home/parallel/parlab30/a1/FW-serial
export OMP_NUM_THREADS=1

./fw 1024

./fw_sr 1024 512
./fw_sr 1024 256
./fw_sr 1024 128
./fw_sr 1024 64

./fw_tiled 1024 512
./fw_tiled 1024 256
./fw_tiled 1024 128
./fw_tiled 1024 64

./fw_tl_parallel_for 1024 512
./fw_tl_parallel_for 1024 256
./fw_tl_parallel_for 1024 128
./fw_tl_parallel_for 1024 64

./fw_tl_parallel_tasks 1024 512
./fw_tl_parallel_tasks 1024 256
./fw_tl_parallel_tasks 1024 128
./fw_tl_parallel_tasks 1024 64

./fw_sr_sections 1024 512
./fw_sr_sections 1024 256
./fw_sr_sections 1024 128
./fw_sr_sections 1024 64

./fw_sr_tasks 1024 512
./fw_sr_tasks 1024 256
./fw_sr_tasks 1024 128
./fw_sr_tasks 1024 64

./fw 2048

./fw_sr 2048 1024
./fw_sr 2048 512
./fw_sr 2048 256
./fw_sr 2048 128
./fw_sr 2048 64

./fw_tiled 2048 1024
./fw_tiled 2048 512
./fw_tiled 2048 256
./fw_tiled 2048 128
./fw_tiled 2048 64

./fw_tl_parallel_for 2048 1024
./fw_tl_parallel_for 2048 512
./fw_tl_parallel_for 2048 256
./fw_tl_parallel_for 2048 128
./fw_tl_parallel_for 2048 64

./fw_tl_parallel_tasks 2048 1024
./fw_tl_parallel_tasks 2048 512
./fw_tl_parallel_tasks 2048 256
./fw_tl_parallel_tasks 2048 128
./fw_tl_parallel_tasks 2048 64

./fw_sr_sections 2048 1024
./fw_sr_sections 2048 512
./fw_sr_sections 2048 256
./fw_sr_sections 2048 128
./fw_sr_sections 2048 64

./fw_sr_tasks 2048 1024
./fw_sr_tasks 2048 512
./fw_sr_tasks 2048 256
./fw_sr_tasks 2048 128
./fw_sr_tasks 2048 64

./fw 4096

./fw_sr 4096 2048
./fw_sr 4096 1024
./fw_sr 4096 512
./fw_sr 4096 256
./fw_sr 4096 128
./fw_sr 4096 64

./fw_tiled 4096 2048
./fw_tiled 4096 1024
./fw_tiled 4096 512
./fw_tiled 4096 256
./fw_tiled 4096 128
./fw_tiled 4096 64

./fw_tl_parallel_for 4096 2048
./fw_tl_parallel_for 4096 1024
./fw_tl_parallel_for 4096 512
./fw_tl_parallel_for 4096 256
./fw_tl_parallel_for 4096 128
./fw_tl_parallel_for 4096 64

./fw_tl_parallel_tasks 4096 2048
./fw_tl_parallel_tasks 4096 1024
./fw_tl_parallel_tasks 4096 512
./fw_tl_parallel_tasks 4096 256
./fw_tl_parallel_tasks 4096 128
./fw_tl_parallel_tasks 4096 64

./fw_sr_sections 4096 2048
./fw_sr_sections 4096 1024
./fw_sr_sections 4096 512
./fw_sr_sections 4096 256
./fw_sr_sections 4096 128
./fw_sr_sections 4096 64

./fw_sr_tasks 4096 2048
./fw_sr_tasks 4096 1024
./fw_sr_tasks 4096 512
./fw_sr_tasks 4096 256
./fw_sr_tasks 4096 128
./fw_sr_tasks 4096 64

export OMP_NUM_THREADS=2

echo threads,2

./fw 1024

./fw_sr 1024 512
./fw_sr 1024 256
./fw_sr 1024 128
./fw_sr 1024 64

./fw_tiled 1024 512
./fw_tiled 1024 256
./fw_tiled 1024 128
./fw_tiled 1024 64

./fw_tl_parallel_for 1024 512
./fw_tl_parallel_for 1024 256
./fw_tl_parallel_for 1024 128
./fw_tl_parallel_for 1024 64

./fw_tl_parallel_tasks 1024 512
./fw_tl_parallel_tasks 1024 256
./fw_tl_parallel_tasks 1024 128
./fw_tl_parallel_tasks 1024 64

./fw_sr_sections 1024 512
./fw_sr_sections 1024 256
./fw_sr_sections 1024 128
./fw_sr_sections 1024 64

./fw_sr_tasks 1024 512
./fw_sr_tasks 1024 256
./fw_sr_tasks 1024 128
./fw_sr_tasks 1024 64

./fw 2048

./fw_sr 2048 1024
./fw_sr 2048 512
./fw_sr 2048 256
./fw_sr 2048 128
./fw_sr 2048 64

./fw_tiled 2048 1024
./fw_tiled 2048 512
./fw_tiled 2048 256
./fw_tiled 2048 128
./fw_tiled 2048 64

./fw_tl_parallel_for 2048 1024
./fw_tl_parallel_for 2048 512
./fw_tl_parallel_for 2048 256
./fw_tl_parallel_for 2048 128
./fw_tl_parallel_for 2048 64

./fw_tl_parallel_tasks 2048 1024
./fw_tl_parallel_tasks 2048 512
./fw_tl_parallel_tasks 2048 256
./fw_tl_parallel_tasks 2048 128
./fw_tl_parallel_tasks 2048 64

./fw_sr_sections 2048 1024
./fw_sr_sections 2048 512
./fw_sr_sections 2048 256
./fw_sr_sections 2048 128
./fw_sr_sections 2048 64

./fw_sr_tasks 2048 1024
./fw_sr_tasks 2048 512
./fw_sr_tasks 2048 256
./fw_sr_tasks 2048 128
./fw_sr_tasks 2048 64

./fw 4096

./fw_sr 4096 2048
./fw_sr 4096 1024
./fw_sr 4096 512
./fw_sr 4096 256
./fw_sr 4096 128
./fw_sr 4096 64

./fw_tiled 4096 2048
./fw_tiled 4096 1024
./fw_tiled 4096 512
./fw_tiled 4096 256
./fw_tiled 4096 128
./fw_tiled 4096 64

./fw_tl_parallel_for 4096 2048
./fw_tl_parallel_for 4096 1024
./fw_tl_parallel_for 4096 512
./fw_tl_parallel_for 4096 256
./fw_tl_parallel_for 4096 128
./fw_tl_parallel_for 4096 64

./fw_tl_parallel_tasks 4096 2048
./fw_tl_parallel_tasks 4096 1024
./fw_tl_parallel_tasks 4096 512
./fw_tl_parallel_tasks 4096 256
./fw_tl_parallel_tasks 4096 128
./fw_tl_parallel_tasks 4096 64

./fw_sr_sections 4096 2048
./fw_sr_sections 4096 1024
./fw_sr_sections 4096 512
./fw_sr_sections 4096 256
./fw_sr_sections 4096 128
./fw_sr_sections 4096 64

./fw_sr_tasks 4096 2048
./fw_sr_tasks 4096 1024
./fw_sr_tasks 4096 512
./fw_sr_tasks 4096 256
./fw_sr_tasks 4096 128
./fw_sr_tasks 4096 64

export OMP_NUM_THREADS=4

echo threads,4

./fw 1024

./fw_sr 1024 512
./fw_sr 1024 256
./fw_sr 1024 128
./fw_sr 1024 64

./fw_tiled 1024 512
./fw_tiled 1024 256
./fw_tiled 1024 128
./fw_tiled 1024 64

./fw_tl_parallel_for 1024 512
./fw_tl_parallel_for 1024 256
./fw_tl_parallel_for 1024 128
./fw_tl_parallel_for 1024 64

./fw_tl_parallel_tasks 1024 512
./fw_tl_parallel_tasks 1024 256
./fw_tl_parallel_tasks 1024 128
./fw_tl_parallel_tasks 1024 64

./fw_sr_sections 1024 512
./fw_sr_sections 1024 256
./fw_sr_sections 1024 128
./fw_sr_sections 1024 64

./fw_sr_tasks 1024 512
./fw_sr_tasks 1024 256
./fw_sr_tasks 1024 128
./fw_sr_tasks 1024 64

./fw 2048

./fw_sr 2048 1024
./fw_sr 2048 512
./fw_sr 2048 256
./fw_sr 2048 128
./fw_sr 2048 64

./fw_tiled 2048 1024
./fw_tiled 2048 512
./fw_tiled 2048 256
./fw_tiled 2048 128
./fw_tiled 2048 64

./fw_tl_parallel_for 2048 1024
./fw_tl_parallel_for 2048 512
./fw_tl_parallel_for 2048 256
./fw_tl_parallel_for 2048 128
./fw_tl_parallel_for 2048 64

./fw_tl_parallel_tasks 2048 1024
./fw_tl_parallel_tasks 2048 512
./fw_tl_parallel_tasks 2048 256
./fw_tl_parallel_tasks 2048 128
./fw_tl_parallel_tasks 2048 64

./fw_sr_sections 2048 1024
./fw_sr_sections 2048 512
./fw_sr_sections 2048 256
./fw_sr_sections 2048 128
./fw_sr_sections 2048 64

./fw_sr_tasks 2048 1024
./fw_sr_tasks 2048 512
./fw_sr_tasks 2048 256
./fw_sr_tasks 2048 128
./fw_sr_tasks 2048 64

./fw 4096

./fw_sr 4096 2048
./fw_sr 4096 1024
./fw_sr 4096 512
./fw_sr 4096 256
./fw_sr 4096 128
./fw_sr 4096 64

./fw_tiled 4096 2048
./fw_tiled 4096 1024
./fw_tiled 4096 512
./fw_tiled 4096 256
./fw_tiled 4096 128
./fw_tiled 4096 64

./fw_tl_parallel_for 4096 2048
./fw_tl_parallel_for 4096 1024
./fw_tl_parallel_for 4096 512
./fw_tl_parallel_for 4096 256
./fw_tl_parallel_for 4096 128
./fw_tl_parallel_for 4096 64

./fw_tl_parallel_tasks 4096 2048
./fw_tl_parallel_tasks 4096 1024
./fw_tl_parallel_tasks 4096 512
./fw_tl_parallel_tasks 4096 256
./fw_tl_parallel_tasks 4096 128
./fw_tl_parallel_tasks 4096 64

./fw_sr_sections 4096 2048
./fw_sr_sections 4096 1024
./fw_sr_sections 4096 512
./fw_sr_sections 4096 256
./fw_sr_sections 4096 128
./fw_sr_sections 4096 64

./fw_sr_tasks 4096 2048
./fw_sr_tasks 4096 1024
./fw_sr_tasks 4096 512
./fw_sr_tasks 4096 256
./fw_sr_tasks 4096 128
./fw_sr_tasks 4096 64

export OMP_NUM_THREADS=8

echo threads,8

./fw 1024

./fw_sr 1024 512
./fw_sr 1024 256
./fw_sr 1024 128
./fw_sr 1024 64

./fw_tiled 1024 512
./fw_tiled 1024 256
./fw_tiled 1024 128
./fw_tiled 1024 64

./fw_tl_parallel_for 1024 512
./fw_tl_parallel_for 1024 256
./fw_tl_parallel_for 1024 128
./fw_tl_parallel_for 1024 64

./fw_tl_parallel_tasks 1024 512
./fw_tl_parallel_tasks 1024 256
./fw_tl_parallel_tasks 1024 128
./fw_tl_parallel_tasks 1024 64

./fw_sr_sections 1024 512
./fw_sr_sections 1024 256
./fw_sr_sections 1024 128
./fw_sr_sections 1024 64

./fw_sr_tasks 1024 512
./fw_sr_tasks 1024 256
./fw_sr_tasks 1024 128
./fw_sr_tasks 1024 64

./fw 2048

./fw_sr 2048 1024
./fw_sr 2048 512
./fw_sr 2048 256
./fw_sr 2048 128
./fw_sr 2048 64

./fw_tiled 2048 1024
./fw_tiled 2048 512
./fw_tiled 2048 256
./fw_tiled 2048 128
./fw_tiled 2048 64

./fw_tl_parallel_for 2048 1024
./fw_tl_parallel_for 2048 512
./fw_tl_parallel_for 2048 256
./fw_tl_parallel_for 2048 128
./fw_tl_parallel_for 2048 64

./fw_tl_parallel_tasks 2048 1024
./fw_tl_parallel_tasks 2048 512
./fw_tl_parallel_tasks 2048 256
./fw_tl_parallel_tasks 2048 128
./fw_tl_parallel_tasks 2048 64

./fw_sr_sections 2048 1024
./fw_sr_sections 2048 512
./fw_sr_sections 2048 256
./fw_sr_sections 2048 128
./fw_sr_sections 2048 64

./fw_sr_tasks 2048 1024
./fw_sr_tasks 2048 512
./fw_sr_tasks 2048 256
./fw_sr_tasks 2048 128
./fw_sr_tasks 2048 64

./fw 4096

./fw_sr 4096 2048
./fw_sr 4096 1024
./fw_sr 4096 512
./fw_sr 4096 256
./fw_sr 4096 128
./fw_sr 4096 64

./fw_tiled 4096 2048
./fw_tiled 4096 1024
./fw_tiled 4096 512
./fw_tiled 4096 256
./fw_tiled 4096 128
./fw_tiled 4096 64

./fw_tl_parallel_for 4096 2048
./fw_tl_parallel_for 4096 1024
./fw_tl_parallel_for 4096 512
./fw_tl_parallel_for 4096 256
./fw_tl_parallel_for 4096 128
./fw_tl_parallel_for 4096 64

./fw_tl_parallel_tasks 4096 2048
./fw_tl_parallel_tasks 4096 1024
./fw_tl_parallel_tasks 4096 512
./fw_tl_parallel_tasks 4096 256
./fw_tl_parallel_tasks 4096 128
./fw_tl_parallel_tasks 4096 64

./fw_sr_sections 4096 2048
./fw_sr_sections 4096 1024
./fw_sr_sections 4096 512
./fw_sr_sections 4096 256
./fw_sr_sections 4096 128
./fw_sr_sections 4096 64

./fw_sr_tasks 4096 2048
./fw_sr_tasks 4096 1024
./fw_sr_tasks 4096 512
./fw_sr_tasks 4096 256
./fw_sr_tasks 4096 128
./fw_sr_tasks 4096 64

export OMP_NUM_THREADS=16

echo threads,16

./fw 1024

./fw_sr 1024 512
./fw_sr 1024 256
./fw_sr 1024 128
./fw_sr 1024 64

./fw_tiled 1024 512
./fw_tiled 1024 256
./fw_tiled 1024 128
./fw_tiled 1024 64

./fw_tl_parallel_for 1024 512
./fw_tl_parallel_for 1024 256
./fw_tl_parallel_for 1024 128
./fw_tl_parallel_for 1024 64

./fw_tl_parallel_tasks 1024 512
./fw_tl_parallel_tasks 1024 256
./fw_tl_parallel_tasks 1024 128
./fw_tl_parallel_tasks 1024 64

./fw_sr_sections 1024 512
./fw_sr_sections 1024 256
./fw_sr_sections 1024 128
./fw_sr_sections 1024 64

./fw_sr_tasks 1024 512
./fw_sr_tasks 1024 256
./fw_sr_tasks 1024 128
./fw_sr_tasks 1024 64

./fw 2048

./fw_sr 2048 1024
./fw_sr 2048 512
./fw_sr 2048 256
./fw_sr 2048 128
./fw_sr 2048 64

./fw_tiled 2048 1024
./fw_tiled 2048 512
./fw_tiled 2048 256
./fw_tiled 2048 128
./fw_tiled 2048 64

./fw_tl_parallel_for 2048 1024
./fw_tl_parallel_for 2048 512
./fw_tl_parallel_for 2048 256
./fw_tl_parallel_for 2048 128
./fw_tl_parallel_for 2048 64

./fw_tl_parallel_tasks 2048 1024
./fw_tl_parallel_tasks 2048 512
./fw_tl_parallel_tasks 2048 256
./fw_tl_parallel_tasks 2048 128
./fw_tl_parallel_tasks 2048 64

./fw_sr_sections 2048 1024
./fw_sr_sections 2048 512
./fw_sr_sections 2048 256
./fw_sr_sections 2048 128
./fw_sr_sections 2048 64

./fw_sr_tasks 2048 1024
./fw_sr_tasks 2048 512
./fw_sr_tasks 2048 256
./fw_sr_tasks 2048 128
./fw_sr_tasks 2048 64

./fw 4096

./fw_sr 4096 2048
./fw_sr 4096 1024
./fw_sr 4096 512
./fw_sr 4096 256
./fw_sr 4096 128
./fw_sr 4096 64

./fw_tiled 4096 2048
./fw_tiled 4096 1024
./fw_tiled 4096 512
./fw_tiled 4096 256
./fw_tiled 4096 128
./fw_tiled 4096 64

./fw_tl_parallel_for 4096 2048
./fw_tl_parallel_for 4096 1024
./fw_tl_parallel_for 4096 512
./fw_tl_parallel_for 4096 256
./fw_tl_parallel_for 4096 128
./fw_tl_parallel_for 4096 64

./fw_tl_parallel_tasks 4096 2048
./fw_tl_parallel_tasks 4096 1024
./fw_tl_parallel_tasks 4096 512
./fw_tl_parallel_tasks 4096 256
./fw_tl_parallel_tasks 4096 128
./fw_tl_parallel_tasks 4096 64

./fw_sr_sections 4096 2048
./fw_sr_sections 4096 1024
./fw_sr_sections 4096 512
./fw_sr_sections 4096 256
./fw_sr_sections 4096 128
./fw_sr_sections 4096 64

./fw_sr_tasks 4096 2048
./fw_sr_tasks 4096 1024
./fw_sr_tasks 4096 512
./fw_sr_tasks 4096 256
./fw_sr_tasks 4096 128
./fw_sr_tasks 4096 64

export OMP_NUM_THREADS=32

echo threads,32

./fw 1024

./fw_sr 1024 512
./fw_sr 1024 256
./fw_sr 1024 128
./fw_sr 1024 64

./fw_tiled 1024 512
./fw_tiled 1024 256
./fw_tiled 1024 128
./fw_tiled 1024 64

./fw_tl_parallel_for 1024 512
./fw_tl_parallel_for 1024 256
./fw_tl_parallel_for 1024 128
./fw_tl_parallel_for 1024 64

./fw_tl_parallel_tasks 1024 512
./fw_tl_parallel_tasks 1024 256
./fw_tl_parallel_tasks 1024 128
./fw_tl_parallel_tasks 1024 64

./fw_sr_sections 1024 512
./fw_sr_sections 1024 256
./fw_sr_sections 1024 128
./fw_sr_sections 1024 64

./fw_sr_tasks 1024 512
./fw_sr_tasks 1024 256
./fw_sr_tasks 1024 128
./fw_sr_tasks 1024 64

./fw 2048

./fw_sr 2048 1024
./fw_sr 2048 512
./fw_sr 2048 256
./fw_sr 2048 128
./fw_sr 2048 64

./fw_tiled 2048 1024
./fw_tiled 2048 512
./fw_tiled 2048 256
./fw_tiled 2048 128
./fw_tiled 2048 64

./fw_tl_parallel_for 2048 1024
./fw_tl_parallel_for 2048 512
./fw_tl_parallel_for 2048 256
./fw_tl_parallel_for 2048 128
./fw_tl_parallel_for 2048 64

./fw_tl_parallel_tasks 2048 1024
./fw_tl_parallel_tasks 2048 512
./fw_tl_parallel_tasks 2048 256
./fw_tl_parallel_tasks 2048 128
./fw_tl_parallel_tasks 2048 64

./fw_sr_sections 2048 1024
./fw_sr_sections 2048 512
./fw_sr_sections 2048 256
./fw_sr_sections 2048 128
./fw_sr_sections 2048 64

./fw_sr_tasks 2048 1024
./fw_sr_tasks 2048 512
./fw_sr_tasks 2048 256
./fw_sr_tasks 2048 128
./fw_sr_tasks 2048 64

./fw 4096

./fw_sr 4096 2048
./fw_sr 4096 1024
./fw_sr 4096 512
./fw_sr 4096 256
./fw_sr 4096 128
./fw_sr 4096 64

./fw_tiled 4096 2048
./fw_tiled 4096 1024
./fw_tiled 4096 512
./fw_tiled 4096 256
./fw_tiled 4096 128
./fw_tiled 4096 64

./fw_tl_parallel_for 4096 2048
./fw_tl_parallel_for 4096 1024
./fw_tl_parallel_for 4096 512
./fw_tl_parallel_for 4096 256
./fw_tl_parallel_for 4096 128
./fw_tl_parallel_for 4096 64

./fw_tl_parallel_tasks 4096 2048
./fw_tl_parallel_tasks 4096 1024
./fw_tl_parallel_tasks 4096 512
./fw_tl_parallel_tasks 4096 256
./fw_tl_parallel_tasks 4096 128
./fw_tl_parallel_tasks 4096 64

./fw_sr_sections 4096 2048
./fw_sr_sections 4096 1024
./fw_sr_sections 4096 512
./fw_sr_sections 4096 256
./fw_sr_sections 4096 128
./fw_sr_sections 4096 64

./fw_sr_tasks 4096 2048
./fw_sr_tasks 4096 1024
./fw_sr_tasks 4096 512
./fw_sr_tasks 4096 256
./fw_sr_tasks 4096 128
./fw_sr_tasks 4096 64

export OMP_NUM_THREADS=64

echo threads,64

./fw 1024

./fw_sr 1024 512
./fw_sr 1024 256
./fw_sr 1024 128
./fw_sr 1024 64

./fw_tiled 1024 512
./fw_tiled 1024 256
./fw_tiled 1024 128
./fw_tiled 1024 64

./fw_tl_parallel_for 1024 512
./fw_tl_parallel_for 1024 256
./fw_tl_parallel_for 1024 128
./fw_tl_parallel_for 1024 64

./fw_tl_parallel_tasks 1024 512
./fw_tl_parallel_tasks 1024 256
./fw_tl_parallel_tasks 1024 128
./fw_tl_parallel_tasks 1024 64

./fw_sr_sections 1024 512
./fw_sr_sections 1024 256
./fw_sr_sections 1024 128
./fw_sr_sections 1024 64

./fw_sr_tasks 1024 512
./fw_sr_tasks 1024 256
./fw_sr_tasks 1024 128
./fw_sr_tasks 1024 64

./fw 2048

./fw_sr 2048 1024
./fw_sr 2048 512
./fw_sr 2048 256
./fw_sr 2048 128
./fw_sr 2048 64

./fw_tiled 2048 1024
./fw_tiled 2048 512
./fw_tiled 2048 256
./fw_tiled 2048 128
./fw_tiled 2048 64

./fw_tl_parallel_for 2048 1024
./fw_tl_parallel_for 2048 512
./fw_tl_parallel_for 2048 256
./fw_tl_parallel_for 2048 128
./fw_tl_parallel_for 2048 64

./fw_tl_parallel_tasks 2048 1024
./fw_tl_parallel_tasks 2048 512
./fw_tl_parallel_tasks 2048 256
./fw_tl_parallel_tasks 2048 128
./fw_tl_parallel_tasks 2048 64

./fw_sr_sections 2048 1024
./fw_sr_sections 2048 512
./fw_sr_sections 2048 256
./fw_sr_sections 2048 128
./fw_sr_sections 2048 64

./fw_sr_tasks 2048 1024
./fw_sr_tasks 2048 512
./fw_sr_tasks 2048 256
./fw_sr_tasks 2048 128
./fw_sr_tasks 2048 64

./fw 4096

./fw_sr 4096 2048
./fw_sr 4096 1024
./fw_sr 4096 512
./fw_sr 4096 256
./fw_sr 4096 128
./fw_sr 4096 64

./fw_tiled 4096 2048
./fw_tiled 4096 1024
./fw_tiled 4096 512
./fw_tiled 4096 256
./fw_tiled 4096 128
./fw_tiled 4096 64

./fw_tl_parallel_for 4096 2048
./fw_tl_parallel_for 4096 1024
./fw_tl_parallel_for 4096 512
./fw_tl_parallel_for 4096 256
./fw_tl_parallel_for 4096 128
./fw_tl_parallel_for 4096 64

./fw_tl_parallel_tasks 4096 2048
./fw_tl_parallel_tasks 4096 1024
./fw_tl_parallel_tasks 4096 512
./fw_tl_parallel_tasks 4096 256
./fw_tl_parallel_tasks 4096 128
./fw_tl_parallel_tasks 4096 64

./fw_sr_sections 4096 2048
./fw_sr_sections 4096 1024
./fw_sr_sections 4096 512
./fw_sr_sections 4096 256
./fw_sr_sections 4096 128
./fw_sr_sections 4096 64

./fw_sr_tasks 4096 2048
./fw_sr_tasks 4096 1024
./fw_sr_tasks 4096 512
./fw_sr_tasks 4096 256
./fw_sr_tasks 4096 128
./fw_sr_tasks 4096 64