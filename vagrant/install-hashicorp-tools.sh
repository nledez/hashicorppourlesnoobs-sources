#!/bin/bash
set -x
TERRAFORM_VERSION=0.11.10
CONSUL_VERSION=1.4.0
VAULT_VERSION=0.11.5
NOMAD_VERSION=0.8.6

dpkg -l unzip >/dev/null 2>&1
if [ "$?" != "0" ]; then
	echo "Need to install unzip"
	sudo apt-get -q update
	sudo apt-get install -qqy -o=Dpkg::Use-Pty=0 -o Dpkg::Options::="--force-confold" unzip
fi

if [ ! -f /usr/local/bin/terraform ]; then
	if [ ! -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip ]; then
		wget --quiet https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
	fi
	if [ -f terraform ]; then
		rm terraform
	fi
	unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
	sudo mv terraform /usr/local/bin/terraform
	sudo chmod +x /usr/local/bin/terraform
fi

if [ ! -f /usr/local/bin/consul ]; then
	if [ ! -f consul_${CONSUL_VERSION}_linux_amd64.zip ]; then
		wget --quiet https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip
	fi
	if [ -f consul ]; then
		rm consul
	fi
	unzip consul_${CONSUL_VERSION}_linux_amd64.zip
	sudo mv consul /usr/local/bin/consul
	sudo chmod +x /usr/local/bin/consul
fi

if [ ! -f /usr/local/bin/vault ]; then
	if [ ! -f vault_${VAULT_VERSION}_linux_amd64.zip ]; then
		wget --quiet https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip
	fi
	if [ -f vault ]; then
		rm vault
	fi
	unzip vault_${VAULT_VERSION}_linux_amd64.zip
	sudo mv vault /usr/local/bin/vault
	sudo chmod +x /usr/local/bin/vault
fi

if [ ! -f /usr/local/bin/nomad ]; then
	if [ ! -f nomad_${NOMAD_VERSION}_linux_amd64.zip ]; then
		wget --quiet https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip
	fi
	if [ -f nomad ]; then
		rm nomad
	fi
	unzip nomad_${NOMAD_VERSION}_linux_amd64.zip
	sudo mv nomad /usr/local/bin/nomad
	sudo chmod +x /usr/local/bin/nomad
fi
