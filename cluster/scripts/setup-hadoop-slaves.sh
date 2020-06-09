#!/bin/bash
# http://stackoverflow.com/questions/6348902/how-can-i-add-numbers-in-a-bash-script

HADOOP_PREFIX=/usr/local/hadoop
HADOOP_CONF=${HADOOP_PREFIX}/etc/hadoop
HADOOP_VERSION=hadoop-2.7.7
HADOOP_ARCHIVE=${HADOOP_VERSION}.tar.gz
HADOOP_MIRROR_DOWNLOAD=../resources/hadoop-2.7.7.tar.gz
HADOOP_RES_DIR=/vagrant/resources/hadoop

HOSTS=(slave1 slave2)

function setupSlaves {
    for node in "${HOSTS[@]}"
    do
        echo "adding ${node}"
        echo "${node}" >> ${HADOOP_CONF}/slaves
    done
}

echo "setup hadoop slaves"
setupSlaves