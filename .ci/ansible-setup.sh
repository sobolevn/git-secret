#!/bin/sh
## Script is specifically for use on travis-ci

set -e

## This is an example setup script that you would encapsulate the installation
# What version of avm setup to use
echo "Setting up Ansible Version Manager"
AVM_VERSION="v1.0.0"
## Install Ansible 2.8.X using pip and label it 'v2.8'
export ANSIBLE_VERSIONS_0="2.8.1.0"
export INSTALL_TYPE_0="pip3"
export ANSIBLE_LABEL_0="v2.8"
# Whats the default version
export ANSIBLE_DEFAULT_VERSION="v2.8"

## Create a temp dir to download avm
avm_dir="$(mktemp -d 2> /dev/null || mktemp -d -t 'mytmpdir')"
git clone https://github.com/ahelal/avm.git "${avm_dir}" > /dev/null 2>&1

## Run the setup
/bin/sh ${avm_dir}/setup.sh

exit 0
