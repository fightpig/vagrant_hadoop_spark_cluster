Setting Up Hadoop 2.7.3 + Spark 2.1
============================

# 1. Introduction
### Vagrant project to spin up a cluster of 4, 64-bit CentOS7 Linux virtual machines with Hadoop v2.7.3 and Spark v2.1. 
Ideal for development cluster on a laptop with at least 4GB of memory.

1. head : HDFS NameNode + Spark Master
2. body : YARN ResourceManager + JobHistoryServer + ProxyServer
3. slave1 : HDFS DataNode + YARN NodeManager + Spark Slave
4. slave2 : HDFS DataNode + YARN NodeManager + Spark Slave

# 2. Prerequisites
1. At least 1GB memory for each VM node. Default script is for 4 nodes, so you need 4GB for the nodes, in addition to the memory for your host machine.
2. Vagrant 1.9.2, Virtualbox 5.1.14 (Use the exact version specified to avoid compatibility issues)
3. Preserve the Unix/OSX end-of-line (EOL) characters while cloning this project; scripts will fail with Windows EOL characters.
4. Project is tested on Centos 7.2 host OS; not tested with VMware provider for Vagrant.
5. The Vagrant box is downloaded to the ~/.vagrant.d/boxes directory. On Windows, this is C:/Users/{your-username}/.vagrant.d/boxes.

# 3. Getting Started
1. [Download and install VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. [Download and install Vagrant](http://www.vagrantup.com/downloads.html).
3. Git clone this project, and change directory (cd) into *cluster* (directory).
4. [Download Hadoop 2.7.3 into the /resources directory](http://www.apache.org/dyn/closer.cgi/hadoop/common/hadoop-2.7.3/hadoop-2.7.3.tar.gz)
5. [Download Spark 2.1 into the /resources directory](http://d3kbcqa49mib13.cloudfront.net/spark-2.1.0-bin-hadoop2.7.tgz)
6. Run ```vagrant up``` to create the VM.
7. Run ```vagrant ssh head``` to get into your VM.
8. Run ```vagrant destroy``` when you want to destroy and get rid of the VM.

# 4. Post Provisioning
After you have provisioned the cluster, you need to run some commands to initialize your Hadoop cluster. 
SSH into head using ```vagrant ssh head``` Commands below require root permissions. Change to root access using ```sudo su``` or create a new user and grant permissions if you want to use a non-root access. In such a case, you'll need to do this on VMs.

Issue the following command. 

1. $HADOOP_PREFIX/bin/hdfs namenode -format myhadoop

## Start Hadoop Daemons (HDFS + YARN)
SSH into head and issue the following commands to start HDFS.```vagrant ssh head```

1. $HADOOP_PREFIX/sbin/hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start namenode
2. $HADOOP_PREFIX/sbin/hadoop-daemons.sh --config $HADOOP_CONF_DIR --script hdfs start datanode

SSH into body and issue the following commands to start YARN.```vagrant ssh body```

1. $HADOOP_YARN_HOME/sbin/yarn-daemon.sh --config $HADOOP_CONF_DIR start resourcemanager
2. $HADOOP_YARN_HOME/sbin/yarn-daemons.sh --config $HADOOP_CONF_DIR start nodemanager
3. $HADOOP_YARN_HOME/sbin/yarn-daemon.sh start proxyserver --config $HADOOP_CONF_DIR
4. $HADOOP_PREFIX/sbin/mr-jobhistory-daemon.sh start historyserver --config $HADOOP_CONF_DIR

### Test YARN
Run the following command to make sure you can run a MapReduce job.

```
vagrant ssh body
yarn jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar pi 2 100
```

## Start Spark in Standalone Mode
SSH into head and issue the following command.```vagrant ssh head```

1. $SPARK_HOME/sbin/start-all.sh

### Test Spark on YARN
You can test if Spark can run on YARN by issuing the following command. Try NOT to run this command on the slave nodes.```vagrant ssh head```
```
$SPARK_HOME/bin/spark-submit --class org.apache.spark.examples.SparkPi \
    --master yarn-cluster \
    --num-executors 10 \
    --executor-cores 2 \
    $SPARK_HOME/examples/jars/spark-examples*.jar \
    100
```
	
### Test Spark using Shell
Start the Spark shell using the following command. Try NOT to run this command on the slave nodes.```vagrant ssh head```

```
$SPARK_HOME/bin/spark-shell --master spark://head:7077
```

Then go here https://spark.apache.org/docs/latest/quick-start.html to start the tutorial. Most likely, you will have to load data into HDFS to make the tutorial work (Spark cannot read data on the local file system).

# 5. Web UI
You can check the following URLs to monitor the Hadoop daemons.

1. [NameNode] (http://localhost:50070/dfshealth.html)
2. [ResourceManager] (http://localhost:18088/cluster)
3. [JobHistory] (http://localhost:19888/jobhistory)
4. [Spark] (http://localhost:8080)
