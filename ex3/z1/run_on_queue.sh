#!/bin/bash

## Give the Job a descriptive name
#PBS -N accounts_run

## Output and error files
#PBS -o accounts.out
#PBS -e accounts.err

## Limit memory, runtime etc.
#PBS -l walltime=01:00:00

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

MT_CONF=0 ./accounts
MT_CONF=0,8 ./accounts
MT_CONF=0,8,16,24 ./accounts
MT_CONF=0,1,8,9,16,17,24,25 ./accounts
MT_CONF=0,1,2,3,8,9,10,11,16,17,18,19,24,25,26,27 ./accounts
MT_CONF=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31 ./accounts
MT_CONF=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63 ./accounts
