
# Installing and Running the NATS Latency Test

To faciliate testing, we've provided terraforms scripts that will
provision machine instances and run the latency tests.

## Prerequisites

The only required tool is *terraform*.  Terraform installation instructions
can be found [here](https://www.terraform.io/intro/getting-started/install.html).

If you want to regenerate certificates for TLS, optionally you can install CFSSL.  
See the [TLS](##TLS) section below.

You will need a GCP or Packet account and it is advised to have a dedicated cloud vendor project for this test.

## TLS

The provided certificates should work with hostnames set by terraform,
but if you find a need to update them you'll want to install
[CFSSL](https://github.com/cloudflare/cfssl) and modify the relevant
[configuration files](tls-scripts/config).  The certificates can be
regenerated to replace existing certificates by running the
[gencerts.sh](./tls-scripts/gencerts.sh) script from inside the
`tls-scripts` directory.

## Test Setup

**First time usage**:  The first time you are running these scripts you will
want to run the `terraform init` command from the provider's directory.

Supported cloud providers include:

* [GCP](gcp)
* [Packet](packet)

See the relevant `README.MD` files in the cloud vendor directories for specific vendor setup.

## Test Structure

When executing this plan via terraform (e.g. via `terraform apply`), terraform will:

* Provision a NATS server machine, `servera`
* Provision a NATS server machine, `serverb`
* Provision a test client machine, `client`
* Install NATS servers, applications, scripts, certificates, and configuration
* Route the NATS servers
* Launch the NATS servers
* Launch the default run of the latency tests
* Print relevant information about server locations and monitoring urls

This will setup up a latency test that can be envisioned as a triangle.  

```text
Server A - - - - - Server B
    \                /
     \              /
      \            /
       \          /
        \        /
    Latency Test (client)
```

WARNING:  Unlike a lot of performance testing, by default this testing
is aimed to simulate a secure production environment.

To that end, this test is configured with:

* NATS server clustering
* End to End bidirectional TLS (both client and route connections)
* Manual cipher suite overrides
* Filtering of subjects between clustered servers
* Authorization of clients and route connections
* Publish and subscribe authorization for clients

Adjust configuration files as necessary to mirror your environment.

## The latency test client

Having the latency client as a single app own instance is the best way to measure
end to end latency with respect to timing.  As we are in the low microsecond
range of measurements and measuring tail latency on higher end machines,
we need to very accurately measure time deltas.  This either requires sophisticated kernal time syncronization or using the same kernel instance to measure time.  In the interest of simplicity and brevity, we chose the latter.

## Manually running the tests

To manually run tests, ssh to the client machine, and run the [run_tests.sh](client/run_tests.sh) script.

## Thirdparty Results

If you would like to contribute additional test results, we would welcome a PR that adds a `.MD` file describing your testing, environment, and (if applicable) steps to reproduce the test.



