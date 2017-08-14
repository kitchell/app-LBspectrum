#!/bin/bash

#mainly to debug locally
if [ -z $WORKFLOW_DIR ]; then export WORKFLOW_DIR=`pwd`; fi
if [ -z $TASK_DIR ]; then export TASK_DIR=`pwd`; fi
if [ -z $SERVICE_DIR ]; then export SERVICE_DIR=`pwd`; fi

rm -f finished

if [ $ENV == "IUHPC" ]; then
	#clean up previous job (just in case)
	rm -f finished
	#jobid=`qsub $SERVICE_DIR/submit.pbs`
	if [ $HPC == "KARST" ]; then
		#looks like preempt queue has small limit on how many jobs I can queue
		#jobid=`qsub -q preempt $SERVICE_DIR/submit.pbs`
		qsub $SERVICE_DIR/submit.pbs > jobid
	fi
	if [ $HPC == "CARBONATE" ]; then
		qsub $SERVICE_DIR/submit.pbs > jobid
	fi
	exit $?
fi

if [ $ENV == "VM" ]; then
	nohup time $SERVICE_DIR/submit.pbs > stdout.log 2> stderr.log &
	echo $! > pid
fi
