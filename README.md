# Bocoup Foundation Inc
> our infrastructure, as code

## Bootstrapping
1. Install [AWSCLI] & [Terraform]
2. Log into AWS EC2 console, create a key pair titled "default".
   Download the key and add to your ssh-agent: `ssh-add /path/to/key.pem`
3. Ensure `~/.aws/credentials` has a profile with administrative
   access keys that match `profile` in `terraform/variables.tfvars`

## Managing Infrastructure

#### init
Running `state=<name> make init` configures your local environment to access
the terraform state as stored in S3. This is a prequisite before managing any
of our states.

### plan
Running `state=<name> make plan` compares your local configuration to the
actual deployed infrastructure and prepares a plan to reconcile any
differences.

### apply
After verifying your plan, running `state=<name> make apply` will execute
the changes from your last plan.


[AWSCLI]: http://docs.aws.amazon.com/cli/latest/userguide/installing.html
[Terraform]: https://www.terraform.io/downloads.html
