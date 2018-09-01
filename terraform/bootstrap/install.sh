#!/bin/sh

# Install go
curl -o go.tar https://dl.google.com/go/go1.11.linux-amd64.tar.gz
tar -xvf go.tar 1>/dev/null

# Install git
sudo apt-get update
#sudo apt-get upgrade
sudo apt-get -y install git
sudo apt-get -y install zip unzip

mkdir gopath 2>/dev/null

# setup our environment
. ~/setenv.sh

# Install the NATS server and latency test
echo "Installing NATS components."
gnatsd_version=v1.3.0
wget "https://github.com/nats-io/gnatsd/releases/download/$gnatsd_version/gnatsd-$gnatsd_version-linux-amd64.zip" -O tmp.zip
unzip tmp.zip
mv gnatsd-$gnatsd_version-linux-amd64/gnatsd gnatsd

go get github.com/nats-io/go-nats
go get github.com/nats-io/latency-tests
