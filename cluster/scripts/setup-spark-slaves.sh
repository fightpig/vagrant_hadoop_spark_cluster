#!/bin/bash
# http://stackoverflow.com/questions/6348902/how-can-i-add-numbers-in-a-bash-script
SPARK_VERSION=spark-2.4.5
SPARK_ARCHIVE=${SPARK_VERSION}-bin-hadoop2.7.tgz
SPARK_MIRROR_DOWNLOAD=../resources/spark-2.4.5-bin-hadoop2.7.tgz
SPARK_RES_DIR=/vagrant/resources/spark
SPARK_CONF_DIR=/usr/local/spark/conf

HOSTS=(slave1 slave2)

function setupSlaves {
	echo "modifying spark slaves"
	for node in "${HOSTS[@]}"
	do
		echo "adding ${node}"
		echo "${node}" >> ${SPARK_CONF_DIR}/slaves
	done
}

echo "setup spark slaves"
setupSlaves
