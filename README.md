# Bocoup Foundation Inc
> our infrastructure, as code

## Bootstrapping
1. Install [AWSCLI] & [Terraform]
2. Log into AWS EC2 console, create a key pair titled "default".
   Download the key and add to your ssh-agent: `ssh-add /path/to/key.pem`
3. Ensure `~/.aws/credentials` has a profile with administrative
   access keys that match `profile` in `terraform/variables.tfvars`

### Commands Available
The most common lifecycle commands `init`, `plan`, and `apply` have been aliased
in the project's Makefile. If more complex management is needed, just `cd` into
the appropriate `terraform/state/` folder and run terraform directly.

#### make [state]/init
Prepare Terraform to manage the state you've specified. This must be run once
before the other commands are accessible.

#### make [state]/plan
Compare your local configuration to the actual deployed infrastructure and
prepare a plan to reconcile any differences.

#### make [state]/apply
After verifying plan, execute the changes.

[AWSCLI]: http://docs.aws.amazon.com/cli/latest/userguide/installing.html
[Terraform]: https://www.terraform.io/downloads.html
