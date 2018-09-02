#!/bin/sh

#
# cfssl must be installed.
#
cfssl gencert -initca config/ca-csr.json | cfssljson -bare ca -
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=config/ca-config.json -profile=server config/servera.json | cfssljson -bare servera
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=config/ca-config.json -profile=server config/serverb.json | cfssljson -bare serverb
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=config/ca-config.json -profile=client config/client.json | cfssljson -bare client

# Copy files
cp ca.pem ../servera/
mv servera-key.pem ../servera
mv servera.pem ../servera

cp ca.pem ../serverb
mv serverb-key.pem ../serverb
mv serverb.pem ../serverb

cp ca.pem ../client
mv client-key.pem ../client
mv client.pem ../client

rm ca.pem ca-key.pem *.csr

