FROM debian:sid



####################
# JAVA
####################


RUN apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    rm -rf /var/lib/apt/lists/*


####################
# HADOOP
####################

ENV HADOOP_VERSION	2.6.0
ENV HADOOP_HOME		/usr/local/hadoop
ENV HADOOP_OPTS		-Djava.library.path=/usr/local/hadoop/lib/native
ENV PATH		$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

ENV YARN_RESOURCEMANAGER_USER root
#ENV HADOOP_SECURE_DN_USER root
ENV YARN_NODEMANAGER_USER root

RUN apt-get update && \
    apt-get install -y wget libzip5 libsnappy1v5 libssl-dev && \
    wget http://archive.apache.org/dist/hadoop/core/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz && \
    apt-get remove -y wget && \
    rm -rf /var/lib/apt/lists/* && \
    tar -zxf /hadoop-$HADOOP_VERSION.tar.gz && \
    rm /hadoop-$HADOOP_VERSION.tar.gz && \
    mv hadoop-$HADOOP_VERSION /usr/local/hadoop && \
    mkdir -p /usr/local/hadoop/logs

# Overwrite default HADOOP configuration files with our config files
COPY conf  $HADOOP_HOME/etc/hadoop/

# Formatting HDFS
ENV JAVA_HOME /usr
RUN mkdir -p /data/dfs/data /data/dfs/name /data/dfs/namesecondary && \
    hdfs namenode -format
VOLUME /data
VOLUME /jars

####################
# OOZIE 
# Refer to the following guide for more info: https://oozie.apache.org/docs/4.3.1/
####################

ENV OOZIE_VERSION	4.2.0
ENV MAVEN_VERSION   3.8.8
ENV OOZIE_HOME		/usr/local/oozie
ENV MAVEN_HOME      /usr/local/maven
ENV PATH		    $PATH:$OOZIE_HOME/bin:$MAVEN_HOME/bin

# Install
RUN apt-get update && \
    apt-get install -y zip curl && \
    rm -rf /var/lib/apt/lists/* && \
    # Download Maven binaries to build Oozie source
    curl -O https://dlcdn.apache.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz && \
    tar -xzf /apache-maven-$MAVEN_VERSION-bin.tar.gz && \
    rm /apache-maven-$MAVEN_VERSION-bin.tar.gz && \
    mv /apache-maven-$MAVEN_VERSION $MAVEN_HOME && \
    # Download Oozie source
    curl -O https://archive.apache.org/dist/oozie/$OOZIE_VERSION/oozie-$OOZIE_VERSION.tar.gz && \
    tar -xzf /oozie-$OOZIE_VERSION.tar.gz && \
    rm /oozie-$OOZIE_VERSION.tar.gz && \
    mv /oozie-$OOZIE_VERSION /tmp/oozie-source && \
    cd /tmp/oozie-source && \
    # Build and install the generated distribution
    mvn clean package assembly:single -DskipTests -Phadoop-2,uber -Dhadoop.version=$HADOOP_VERSION && \
    tar -xzf distro/target/oozie-$OOZIE_VERSION-distro.tar.gz -C /tmp && \
    mv /tmp/oozie-$OOZIE_VERSION $OOZIE_HOME && \
    mkdir -p $OOZIE_HOME/libext && \
    # Install ExtJS for the web console
    curl -O https://archive.cloudera.com/gplextras/misc/ext-2.2.zip && \
    mv ext-2.2.zip $OOZIE_HOME/libext && \
    apt-get remove -y curl && \
    rm -rf /tmp/*

# Boostrap oozie metadata db
RUN ooziedb.sh create -run oozie.sql

####################
# PORTS
####################
#
# http://docs.hortonworks.com/HDPDocuments/HDP2/HDP-2.3.0/bk_HDP_Reference_Guide/content/reference_chap2.html
# http://www.cloudera.com/content/cloudera/en/documentation/core/latest/topics/cdh_ig_ports_cdh5.html
# http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/core-default.xml
# http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml

# HDFS: NameNode (NN):
#	 9820 = fs.defaultFS			(IPC / File system metadata operations)
#						(9000 is also frequently used alternatively)
#	 9871 = dfs.namenode.https-address	(HTTPS / Secure UI)
#	 9870 = dfs.namenode.https-address	(HTTPS / Secure UI)
# HDFS: DataNode (DN):
#	9866 = dfs.datanode.address		(Data transfer)
#	9867 = dfs.datanode.ipc.address	(IPC / metadata operations)
#	9864 = dfs.datanode.https.address	(HTTPS / Secure UI)
# HDFS: Secondary NameNode (SNN)
#	9868 = dfs.secondary.http.address	(HTTP / Checkpoint for NameNode metadata)
EXPOSE 9000 9870 9866 9867 9864 9868 8088

EXPOSE 11000 11001

# CMD ["tail", "-f", "/dev/null"]
CMD oozied.sh run
