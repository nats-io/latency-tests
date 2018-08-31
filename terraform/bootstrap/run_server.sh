#!/bin/bash

. ./setenv.sh

echo "Starting NATS server process."
gnatsd -config gnatsd.conf 2>server.err 1>server.out &
disown
echo "Started NATS server."
sleep 5
