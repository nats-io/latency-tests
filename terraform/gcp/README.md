# NATS Latency Testing on GCP

## Getting Started

A prerequisite to running this test on GCP is to setup a GCP account that can run  

1. Create a GCP account and project.
2. Generate an account.json file, as described [here].(https://medium.com/@josephbleroy/using-terraform-with-google-cloud-platform-part-1-n-6b5e4074c059)
3. Enable the compute engine API and ensure proper permissions are set.

## First time Usage

From this directory, to provision the test instances, simply run the command:
`$ terraform apply`

This will setup the latency tests described in the higher level terraform [README.md](../readme.md).

## Setting up and running the test

Once all of the permissions and keys are setup, you can run the test.  From this
directory, run `terraform apply`.

Next, SSH to the client machine and run tests.  The `run_tests.sh` runs a series of tests and provides a good starting point.

### Variables

You can enter the variables via command line, manually when you run the test, or create a `terraform.tfvars` file with your variables required to run.   You can override other
variables found in [variables.tf](variables.tf)

Here is an example:

```text
project="nats-latency-testing"
account_json_file="terraform-account.json"
username="colin"
server_type = "f1-micro"
client_type = "f1-micro"

# You can override other variables
# e.g.
# private_key_file = "gce_private_key.pem"
# zone = "asia-south1"
# region = "asia-south1-c"
```