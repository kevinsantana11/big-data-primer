FROM debian:sid

####################
# JAVA
####################

RUN apt-get update && \
	apt-get install -y openjdk-8-jdk && \
	rm -rf /var/lib/apt/lists/*

####################
# SPARK
####################

ENV SPARK_VERSION=3.3.0
ENV HADOOP_VERSION=3


ENV SPARK_HOME /usr/local/spark
ENV PATH $SPARK_HOME/bin:$PATH

RUN apt-get update \
  	&& apt-get install -y curl net-tools iputils-ping bind9-dnsutils \
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
EXPOSE 8080 8081 7077 6066 4040