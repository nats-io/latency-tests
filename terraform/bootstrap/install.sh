#!/bin/sh

# Install go
curl -o go.tar https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz
tar -xvf go.tar 1>/dev/null

# Install git
sudo apt-get update
#sudo apt-get upgrade
sudo apt-get -y install git

mkdir gopath 2>/dev/null

# setup our environment
. ~/setenv.sh

echo "Installing NATS components."
go get github.com/nats-io/gnatsd
go get github.com/nats-io/go-nats
go get github.com/nats-io/latency-tests

