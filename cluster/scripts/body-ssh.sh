#!/usr/bin/env bash

function createSSHKey {
    echo "generating ssh keys..."
    ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
    cp -f /vagrant/resources/ssh/config ~/.ssh
}

function sshCopyId {
    HOSTS=(slave1 slave2)
    for node in "${HOSTS[@]}"
    do
        echo "setting up key for $node"
        sshpass -p vagrant ssh-copy-id -i ~/.ssh/id_rsa.pub ${node}
    done
}

echo "Setting up remote ssh for HEAD..."
createSSHKey
sshCopyId
