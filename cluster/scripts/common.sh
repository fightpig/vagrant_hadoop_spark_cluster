#!/usr/bin/env bash

function disableFirewall {
    echo "Disabling Firewall..."
    systemctl stop firewalld
}

function setupHostFile {
    head="192.168.100.100   head.local  head"
    body="192.168.100.101   body.local  body"
    slave1="192.168.100.102   slave1.local  slave1"
    slave2="192.168.100.103   slave2.local  slave2"
    echo "${head}" >> /etc/nhosts
    echo "${body}" >> /etc/nhosts
    echo "${slave1}" >> /etc/nhosts
    echo "${slave2}" >> /etc/nhosts
    echo "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4" >> /etc/nhosts
	echo "::1         localhost localhost.localdomain localhost6 localhost6.localdomain6" >> /etc/nhosts
	cp /etc/nhosts /etc/hosts
	rm -f /etc/nhosts
}

function updateYumRepo {
    echo "********** begin updating yum repo **********"
    mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
    mv /vagrant/resources/CentOS7-Base-163.repo /etc/yum.repos.d/CentOS-Base.repo
    yum clean all
    yum makecache
#    yum -y update # 升级所有包同时也升级软件和系统内核
#    yum -y upgrade # 只升级所有包，不升级软件和系统内核
    echo "********** updating yum repo finished **********"
}

updateYumRepo
yum -y update
yum -y install epel-release
yum -y install kernel-devel gcc make
yum -y install nano
yum -y install sshpass
disableFirewall
setupHostFile
