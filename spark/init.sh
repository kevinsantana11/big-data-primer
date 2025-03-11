#!/bin/bash
# Expects one argument <worker|master>
set -x

if  [[ $# -gt 0 ]] && [[ "$1" == "worker" ]]; then
	shift 1
	spark-class org.apache.spark.deploy.worker.Worker $@
elif [[ $# -gt 0 ]] && [[ "$1" == "master" ]]; then
	shift 1
	spark-class org.apache.spark.deploy.master.Master $@
else
	echo "unkown action $1"
fi
