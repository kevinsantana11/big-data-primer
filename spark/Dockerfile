FROM debian:sid

ENV ENABLE_INIT_DAEMON false
ENV INIT_DAEMON_BASE_URI http://identifier/init-daemon
ENV INIT_DAEMON_STEP spark_master_init

ENV BASE_URL=https://archive.apache.org/dist/spark/
ENV SPARK_VERSION=3.3.0
ENV HADOOP_VERSION=3

####################
# JAVA
####################

RUN apt-get update && \
	apt-get install -y openjdk-8-jdk && \
	rm -rf /var/lib/apt/lists/*

####################
# SPARK

# SPARK_MASTER_HOST
# SPARK_MASTER_PORT
# SPARK_MASTER_WEBUI_PORT
####################

ENV SPARK_HOME /usr/local/spark
ENV PATH $SPARK_HOME/bin:$PATH
ENV SPARK_MASTER_PORT 7077
ENV SPARK_MASTER_WEBUI_PORT 8081
ENV SPARK_WORKER_WEBUI_PORT 8080

RUN apt-get update \
  	&& apt-get install -y curl \
  	&& curl -O https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz \
  	&& tar -xvzf spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz \
  	&& mv spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION $SPARK_HOME \
  	&& rm spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz \
  	&& rm -rf /var/lib/apt/lists/* \
  	&& apt-get remove -y curl

#Give permission to execute scripts
ADD init.sh /usr/local/bin/init
RUN chmod +x /usr/local/bin/init

VOLUME /jars

####################
# PORTS
# SPARK: Master:
# 	7077 = Spark master port
# 	8081 = Spark master web ui port

# SPARK: Worker:
# 	8080 = Spark worker web ui port
####################
EXPOSE 8080 8081 7077 6066