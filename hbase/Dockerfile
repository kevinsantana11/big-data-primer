FROM debian:sid



####################
# JAVA
####################


RUN apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    rm -rf /var/lib/apt/lists/*


####################
# HBASE
####################

ENV HBASE_VERSION	2.5.10
ENV HBASE_HOME		/usr/local/hbase
ENV PATH		$PATH:$HBASE_HOME/bin:$HBASE_HOME/sbin

RUN apt-get update && \
    apt-get install -y curl && \
    curl -O https://downloads.apache.org/hbase/stable/hbase-${HBASE_VERSION}-bin.tar.gz && \
    apt-get remove -y curl && \
    rm -rf /var/lib/apt/lists/* && \
    tar -zxf /hbase-$HBASE_VERSION-bin.tar.gz && \
    rm /hbase-$HBASE_VERSION-bin.tar.gz && \
    mv hbase-$HBASE_VERSION /usr/local/hbase


# Overwrite default HADOOP configuration files with our config files
COPY conf  $HBASE_HOME/
ENV JAVA_HOME /usr

# REST API
EXPOSE 8080
# REST Web UI at :8085/rest.jsp
EXPOSE 8085
# Thrift API
EXPOSE 9090
# Thrift Web UI at :9095/thrift.jsp
EXPOSE 9095
# HBase's Embedded zookeeper cluster
EXPOSE 2181
# HBase Master web UI at :16010/master-status;  ZK at :16010/zk.jsp
EXPOSE 16010