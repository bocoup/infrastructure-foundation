# Bocoup Foundation Inc
> our infrastructure, as code

## Setup
1. Install [AWSCLI] & [Terraform]
2. Log into AWS EC2 console, create a key pair titled "default".
   Download the key and add to your ssh-agent: `ssh-add /path/to/key.pem`
3. Ensure `~/.aws/credentials` has a profile with administrative
   access keys that match `name` in `terraform.tfvars`
4. Provision your infrastructure: `terraform apply`

[AWSCLI]: http://docs.aws.amazon.com/cli/latest/userguide/installing.html
[Terraform]: https://www.terraform.io/downloads.html
