#!/usr/bin/env bash


function enableSSHPassword {
    ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
    cp -f /vagrant/resources/ssh/sshd_config /etc/ssh
    cp -f /vagrant/resources/ssh/config ~/.ssh/
    systemctl restart sshd
}

echo "Setting up Password Authentication"
enableSSHPassword
