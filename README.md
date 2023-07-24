## This repository is archived
Due to the environment it manages being phased out, the code for its infrastructure is being archived.

# Bocoup Foundation Inc
> our infrastructure, as code

## Bootstrapping
1. Install [AWSCLI] & [Terraform]
2. Ensure `~/.aws/credentials` has a profile with administrative access keys
   that match the `profile` value inside `provider "aws" {}` for the project
   you want to manage (`terraform/<project>/variables.tfvars`).

### Commands Available
The most common lifecycle commands `init`, `plan`, and `apply` have been aliased
in the project's Makefile. If more complex management is needed, just `cd` into
the appropriate `terraform/project/` folder and run terraform directly.

#### make <project>/init
Prepare Terraform to manage the project you've specified. This must be run once
before the other commands are accessible.

#### make <project>/plan
Compare your local configuration to the actual deployed infrastructure and
prepare a plan to reconcile any differences.

#### make <project>/apply
After verifying plan, execute the changes.

[AWSCLI]: http://docs.aws.amazon.com/cli/latest/userguide/installing.html
[Terraform]: https://www.terraform.io/downloads.html
