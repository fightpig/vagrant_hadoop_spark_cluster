#!/bin/bash
SPARK_VERSION=spark-2.4.5
SPARK_ARCHIVE=${SPARK_VERSION}-bin-hadoop2.7.tgz
SPARK_MIRROR_DOWNLOAD=../resources/spark-2.4.5-bin-hadoop2.7.tgz
SPARK_RES_DIR=/vagrant/resources/spark
SPARK_CONF_DIR=/usr/local/spark/conf

function installLocalSpark {
	echo "install spark from local file"
	FILE=/vagrant/resources/${SPARK_ARCHIVE}
	tar -xzf $FILE -C /usr/local
}

function installRemoteSpark {
	echo "install spark from remote file"
	curl -o /vagrant/resources/${SPARK_ARCHIVE} -O -L ${SPARK_MIRROR_DOWNLOAD}
	tar -xzf /vagrant/resources/${SPARK_ARCHIVE} -C /usr/local
}

function setupSpark {
	echo "setup spark"
	cp -f /vagrant/resources/spark/slaves /usr/local/spark/conf
}

function setupEnvVars {
	echo "creating spark environment variables"
	cp -f ${SPARK_RES_DIR}/spark.sh /etc/profile.d/spark.sh
}

function installSpark {
	installLocalSpark
	ln -s /usr/local/${SPARK_VERSION}-bin-hadoop2.7 /usr/local/spark
}

echo "setup spark"

installSpark
setupSpark
setupEnvVars
