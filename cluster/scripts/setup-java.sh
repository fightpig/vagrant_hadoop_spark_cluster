#!/usr/bin/env bash

JDK_ARCHIVE=jdk-8u251-linux-x64.tar.gz

function uninstallOpen() {
    echo "uninstall open jdk if it existed"
    rpm -qa|grep java
    rpm -qa|grep java | awk '{print $0}' | xargs -I {} rpm -e --nodeps {}
}

function installJDK8 {
    echo "installing oracle jdk"
	FILE=/vagrant/resources/${JDK_ARCHIVE}
	tar -xzf ${FILE} -C /usr/local
	ln -s /usr/local/jdk1.8.0_251 /usr/local/java
}

function setupEnvVars {
	echo "creating java environment variables"
	echo export JAVA_HOME=/usr/local/java >> /etc/profile.d/java.sh
	echo export PATH=\${JAVA_HOME}/bin:\${PATH} >> /etc/profile.d/java.sh
}

echo "setup java"
uninstallOpen
installJDK8
setupEnvVars