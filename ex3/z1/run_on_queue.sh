#!/bin/bash

## Give the Job a descriptive name
#PBS -N accounts_run

## Output and error files
#PBS -o accounts.out
#PBS -e accounts.err

## Limit memory, runtime etc.
#PBS -l walltime=00:30:00

## How many machines should we get?
#PBS -l nodes=sandman:ppn=64

## Start

return_seq ()
{
	start=$1
	end=$2
	rValue=$1
	start=`expr "$start" + 1`

	while [ $start -le $end ]
	do
		rValue=$rValue,$start
		start=`expr "$start" + 1`
	done

	echo $rValue
}

cd /home/parallel/parlab30/a3/z1/

echo "\n-----first execution-----\n"

echo "Nthreads, Runtime(secs), Throughput\n"

threads=1
while [ $threads -le 64 ]
do
	offset=0
	temp=0	
	while [ $offset -le `expr "$threads" - 1` ]
	do
		if [ $offset != 0 ]
		then
			temp=$temp,$offset
		fi
		offset=`expr "$offset" + 1`
	done
	MT_CONF=$temp ./accounts
	threads=`expr "$threads" '*' 2`
done

echo "\n-----second execution-----\n"