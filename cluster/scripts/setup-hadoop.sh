#!/bin/bash

HADOOP_PREFIX=/usr/local/hadoop
HADOOP_CONF=${HADOOP_PREFIX}/etc/hadoop
HADOOP_VERSION=hadoop-2.7.7
HADOOP_ARCHIVE=${HADOOP_VERSION}.tar.gz
HADOOP_MIRROR_DOWNLOAD=../resources/hadoop-2.7.7.tar.gz
HADOOP_RES_DIR=/vagrant/resources/hadoop


function installLocalHadoop {
	echo "install hadoop from local file"
	FILE=/vagrant/resources/${HADOOP_ARCHIVE}
	tar -xzf $FILE -C /usr/local
}

function installRemoteHadoop {
	echo "install hadoop from remote file"
	curl -o /vagrant/resources/${HADOOP_ARCHIVE} -O -L ${HADOOP_MIRROR_DOWNLOAD}
	tar -xzf /vagrant/resources/${HADOOP_ARCHIVE} -C /usr/local
}

function setupHadoop {
	echo "creating hadoop directories"
	mkdir /var/hadoop
	mkdir /var/hadoop/hadoop-datanode
	mkdir /var/hadoop/hadoop-namenode
	mkdir /var/hadoop/mr-history
	mkdir /var/hadoop/mr-history/done
	mkdir /var/hadoop/mr-history/tmp

	echo "copying over hadoop configuration files"
	cp -f ${HADOOP_RES_DIR}/* ${HADOOP_CONF}
}

function setupEnvVars {
	echo "creating hadoop environment variables"
	cp -f ${HADOOP_RES_DIR}/hadoop.sh /etc/profile.d/hadoop.sh
	echo "export HADOOP_PREFIX=/${HADOOP_PREFIX}" >> /root/.bashrc
}

function installHadoop {
    installLocalHadoop
	ln -s /usr/local/${HADOOP_VERSION} /usr/local/hadoop
}


echo "setup hadoop"
installHadoop
setupHadoop
setupEnvVars
