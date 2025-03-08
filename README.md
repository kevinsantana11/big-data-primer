# Hadoop Playground
![hadoop logo](https://hadoop.apache.org/images/hadoop-logo.jpg)

## Attribution
I sourced the examples from the apache example repositories:
* [Oracles MapReduce example](https://docs.oracle.com/en-us/iaas/Content/bigdata/hadoop-odh-hadoop-examples.htm)
* [Apache Spark examples](https://github.com/apache/spark/tree/master/examples)
* [Crunch MapReduce exmaple](https://github.com/jwills/crunch-demo)

The docker images and docker compose files were built by referencing the following repositories:
* [docker-hadoop](https://github.com/bigdatafoundation/docker-hadoop)
* [docker-spark](https://github.com/big-data-europe/docker-spark/tree/master)
* For Apache Oozie, I utilized the guide provided on the projects documentation but was only able to build up to version 4.2.0. I noticed online other repositories were using this
and ultimately the other versions would fail to build due to unresolveable dependencies.

## Overview
The purpose of this repository is to setup dev environments utilizing different data processing technologies such as Hadoop, Crunch, Spark, Oozie and friends along with examples repositories
to get you started building code that either interacts with or is executed by a particular technology in the data processing stack.

## Hadoop Cluster(MapReduce/Crunch)
### Starting the cluster
To start the cluster you need to build the image and then initialize the cluster

1. Build the image.

For the 3.3.6 image:

> cd 3.3.6 && docker build --tag hadoop-local:3.3.6 .

For the 2.6.0 image:

> cd 2.6.0 && docker build --tag hadoop-local:2.6.0 .

2. Start the cluster.
> docker compose up -d

3. Remember to clean up the folders created when shutting down the cluster.
> sudo rm -rf datanode-data hdfs-namenode-jars

### Add Data & Submit a Map Reduce job 
For the following instructions it's recommended to run them from within one of the containers in the cluster. You can do this by running the following command:

For the 2.6.0 version:

> docker exec -it 336-namenode-1 /bin/bash

For the 2.6.0 version:

> docker exec -it 260-namenode-1 /bin/bash

1. Add data in HDFS.
> hadoop fs -put /usr/local/hadoop/README.txt /README.txt

2. Run the example Map Reduce job.
> hadoop jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.6.0.jar wordcount  /README.txt /README.result

3. If the result already exists, remove it.
> hadoop fs -rm -R -f /README.result

4. Inspect the result.
> hadoop fs -cat /README.result/\*

### Use your own Map Reduce Job
If you would like to build and use your own Map reduce job follow these instructions. An example repository at the root folder of this repository exists that can be built, executed and modified.

1. Go to the sample Map Reduce code repository `hadoop-wordcount` and build the package.
> cd hadoop-wordcount && mvn clean package
2. The previous step generates a build artifact `wordcount-1.0-SNAPSHOT.jar`. Well want to copy this over into the `/jars` folder that's exposed in the host machine and linked internally to the name node. This makes the **jar** available to be executed within the container. Lets move it.
> sudo cp target/wordcountjava-1.0-SNAPSHOT.jar ../3.3.6/hdfs-namenode-jars
3. Obtain a remote shell into the namenode and run the following command to execute the custom Map Reduce job we just built and copied over.
> hadoop jar /jars/wordcountjava-1.0-SNAPSHOT.jar org.apache.hadoop.examples.WordCount /README.txt /README.result
4. If the result already exists, remove it.
> hadoop fs -rm -R -f /README.result
5. Inspect the result.
> hadoop fs -cat /README.result/\*

### Run a Map Reduce Job Using Crunch
If you want to utilize Apache Crunch for your Hadoop jobs it should be noted that you will want to utilize Hadoop version 2.6.0 and likely want to build your java jar for java <= 1.8. The example repository also contains an example Crunch job. To run that job utilize the following command:
> hadoop jar /jars/wordcountjava-1.0-SNAPSHOT.jar org.apache.hadoop.examples.WordCountCrunch /README.txt /README.result

### Accessing the web interfaces
Each component provide its own web UI. Open you browser at one of the URLs below, where `dockerhost` is the name / IP of the host running the docker daemon. If using Linux, this is the IP of your linux box. If using OSX or Windows (via Boot2docker), you can find out your docker host by typing `boot2docker ip`. On my machine, the NameNode UI is accessible at `http://192.168.59.103:50070/`

| Component               | Port                                               |
| ----------------------- | -------------------------------------------------- |
| HDFS NameNode           | [http://dockerhost:50070](http://dockerhost:50070) |
| HDFS DataNode           | [http://dockerhost:50075](http://dockerhost:50075) |
| HDFS Secondary NameNode | [http://dockerhost:50090](http://dockerhost:50090) |
| YARN Resource Manager   | [http://dockerhost:8088](http://dockerhost:8088) |
| YARN Node Manager   | [http://dockerhost:8042](http://dockerhost:8042) |

## Spark Cluster
### Starting the cluster
To start the cluster you need to build the image and then initialize the cluster

1. Build the image.

For the 3.3.0 image:

> cd spark && docker build --tag spark-local:3.3.0 .

2. Start the cluster.
> docker compose up -d

3. Remember to clean up the folders created when standing up the cluster.
> sudo rm -rf spark-jars

### Submit a Spark job 
For the following instructions it's recommended to run them from within one of the containers in the cluster. You can do this by running the following command:

> docker exec -it spark-master-1 /bin/bash

1. Run the example Spark job, which will output the results to stdout.
> spark-submit --class org.apache.spark.examples.JavaWordCount --master spark://spark-master:7077 /usr/local/spark/examples/jars/spark-examples_2.12-3.3.0.jar file:///var/log/README

...
### Use your own Spark Job
If you would like to build and use your own Spark job follow these instructions. An example repository at the root folder of this repository exists that can be built, executed and modified.

1. Go to the sample Map Reduce code repository `spark-wordcount` and build the package.
> cd spark-wordcount && mvn clean package
2. The previous step generates a build artifact `wordcount-1.0-SNAPSHOT.jar`. Well want to copy this over into the `/jars` folder that's exposed in the host machine and linked internally to the name node. This makes the **jar** available to be executed within the container. Lets move it.
> sudo cp target/wordcountjava-1.0-SNAPSHOT.jar ../spark/spark-jars
3. Obtain a remote shell into the spark-master node and run the following command to execute the custom Spark job we just built and copied over.
> spark-submit --class org.apache.spark.examples.WordCount --master spark://spark-master:7077 /jars/wordcount-1.0-SNAPSHOT.jar file:///var/log/README
