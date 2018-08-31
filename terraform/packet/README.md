
# NATS Latency Testing on Packet

## Getting started

You'll need a packet account and and project setup to run the latency tests.
Once you have generated an API key from the user profile or project section
of your Packet account, you'll need to set the `auth_token` and `project_id`
variables.  More on that below.

## First time Usage

From this directory, to provision the test instances, simply run the command:
`$ terraform apply`

This will setup the latency tests described in the higher level terraform [README.md](../readme.md).

## Setting up and running tests

Once all of the permissions and keys are setup, you can run the test.  From this
directory, run `terraform apply`.

Next, SSH to the client machine and run tests.  The `run_tests.sh` runs a series of tests and provides a good starting point.

## Variables

You can enter the variables via command line, manually when you run the test,
or create a `terraform.tfvars` file with your variables required to run. You
can override other variables found in [variables.tf](variables.tf)

Different machine instances can be selected using the `server_type`
and `client_type` variables. e.g.  Descriptions of available machines can
be found in comments of the `variables.tf` file, although you may want to
check for updates.  More information on terraform packet device types can
be found [here](https://www.terraform.io/docs/providers/packet/r/device.html)

Here is an example:

```text
auth_token="AB23cdeFFgH123lmnopQRstuv134wxyz"
server_type = "baremetal_0"
client_type = "baremetal_1"
project_id="1234567a-1aa1-2bb2-3c3c-0n0a0t0s0ZZZ"
```

## Running the tests

To run the default tests simply run:
`ssh root@<client IP> "~/run_tests.sh"`

This assumes you have added your key to your local keychain.  If not you
may need to use the `-i` option or ssh into the client machine directly.