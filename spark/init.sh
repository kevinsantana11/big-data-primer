#!/bin/bash
# Expects the following environment variables to be configured:

# Worker:
# SPARK_WORKER_WEBUI_PORT

# Master:
# SPARK_MASTER_WEBUI_PORT
set -x

if  [[ $# -gt 0 ]] && [[ "$1" == "worker" ]]; then
	shift 1
	spark-class org.apache.spark.deploy.worker.Worker --webui-port $SPARK_WORKER_WEBUI_PORT $@
elif [[ $# -gt 0 ]] && [[ "$1" == "master" ]]; then
	shift 1
	spark-class org.apache.spark.deploy.master.Master --webui-port $SPARK_MASTER_WEBUI_PORT $@
else
	echo "unkown action $1"
fi
