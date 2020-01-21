#!/bin/bash

## Give the Job a descriptive name
#PBS -N make_locks_z3

## Output and error files
#PBS -o make_locks_z3.out
#PBS -e make_locks_z3.err

## How many machines should we get?
#PBS -l nodes=1:ppn=1

##How long should the job run for?
#PBS -l walltime=00:10:00

## Start
## Run make in the src folder (modify properly)

#path="/home//parlab30/a3/z3/"
path="/media/stelios/Storage/Documents/ECE/Hardware/Parallel_Processing_Systems/parlab/ex3/z3"
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
  counter=0
  for i in "${executables[@]}"
  do
    while [ $((counter+1)) -le ${#percentages[@]} ]
    do
      for j in "${list_sizes[@]}"
      do
        printf "%s %s\n" "$i" "$j"
        start_execution "$i" "$cpus" "$j" "${percentages[$counter]}" "${percentages[$((counter+1))]}" "${percentages[$((counter+2))]}"
      done
    counter=$((counter+3))
    done
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

serial_locks 1
parallel_locks 4
