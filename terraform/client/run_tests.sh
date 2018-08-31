#!/bin/bash

. ./setenv.sh

dur="1s"
tlsvars="--secure -tls_ca ca.pem -tls_cert client.pem -tls_key client-key.pem"

runtest() {
    latency-tests -sa nats://luser:top_secret@servera:4222 -sb nats://luser:top_secret@serverb:4222 -sz $msgsize -tr $msgrate -tt $dur $tlsvars -hist lat_${msgsize}b_by_${msgrate}_mps
}

#
# for each message size we want to test, run iterations of different rates
#
declare -a arr=("256" "512" "1024" "4096")
for i in "${arr[@]}"
do
   msgsize="$i"

   msgrate="1000"
   runtest

   msgrate="10000"
   runtest

   msgrate="100000"
   runtest
done
