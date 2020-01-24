#!/bin/bash

## Give the Job a descriptive name
#PBS -N run_locks

## Output and error files
#PBS -o run_locks.out
#PBS -e run_locks.err

## How many machines should we get?
#PBS -l nodes=sandman:ppn=64

##How long should the job run for?
#PBS -l walltime=05:00:00

path="/home/parallel/parlab30/a3/z3/"
#path="/mnt/Storage/Documents/ECE/Hardware/Parallel_Processing_Systems/parlab/ex3/z3"
cd "$path" || exit

echo "Nthreads, Throughput(Kops/sec), Runtime(sec), Workload, MT_CONF"

executables=("fgl" "opt" "lazy" "nb")
percentages=("80" "10" "10" "20" "40" "40")
list_sizes=("1024" "8192")

start_execution ()
{
  executable=$1
  limit=$2
  list_size=$3
  cnt=$4
  add=$5
  rmv=$6
  threads=1
  while [ $threads -le "$limit" ]
  do
    offset=0
    temp=0
    while [ $offset -le $((threads-1)) ]
    do
      if [ $offset != 0 ]
      then
        temp=$temp,$offset
      fi
      offset=$((offset+1))
    done
    MT_CONF="$temp" ./"$executable" "$list_size" "$cnt" "$add" "$rmv"
    threads=$((threads*2))
  done
}

parallel_locks()
{
  cpus=$1
  length="${#executables[@]}"
  counter=0
  for ((i=0; i<$((length)); i++))
  do
    while [ $((counter+1)) -le ${#percentages[@]} ]
    do
      for j in "${list_sizes[@]}"
      do
        printf "%s %s\n" "${executables[i]}" "$j"
        start_execution "${executables[i]}" "$cpus" "$j" "${percentages[$counter]}" "${percentages[$((counter+1))]}" "${percentages[$((counter+2))]}"
      done
    counter=$((counter+3))
    done
    counter=0
  done
}

serial_locks()
{
  cpus=$1
  counter=0
  while [ $((counter+1)) -le ${#percentages[@]} ]
  do
    for j in "${list_sizes[@]}"
    do
        printf "%s %s\n" "serial" "$j"
        start_execution "serial" "$cpus" "$j" "${percentages[$counter]}" "${percentages[$((counter+1))]}" "${percentages[$((counter+2))]}"
    done
    counter=$((counter+3))
  done
}

#serial_locks 1
parallel_locks 4
