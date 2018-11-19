#!/bin/bash
CONSUL_VERSION=1.4.0

dpkg -l unzip >/dev/null 2>&1
if [ "$?" != "0" ]; then
	echo "Need to install unzip"
	sudo apt-get -q update
	sudo apt-get install -qqy -o=Dpkg::Use-Pty=0 -o Dpkg::Options::="--force-confold" unzip
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
