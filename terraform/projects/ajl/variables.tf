##
# This is primarily used as a convience for tagging resources so operators who
# are looking at the web UI can easily see project delinations. It's also used
# as a prefix in places where the underlying cloud provider requires unique
# names for resources we'd otherwise like to name generically.
#
variable "name" {
  default = "ajl"
}

##
# The name of the master private key to use for all compute resources. This is
# generated once by hand in the AWS EC2 web UI.
#
variable "key_name" {
  default = "ajl"
}

##
# This tells Terraform how to authenticate for AWS resources. It expects
# an entry in ~/.aws/credentials with a matching profile. You can create
# this with `aws configure --profile foundation`.
#
provider "aws" {
  profile = "foundation"
  region = "us-east-1"
}

##
# This tells Terraform where to persist the state of the infrastructure for
# this project. We use S3 so the state doesn't have to be manually checked
# into the repository.
#
terraform {
  backend "s3" {
    bucket = "foundation-terraform"
    key = "ajl.tfstate"
    region = "us-east-1"
    profile = "foundation"
  }
}

##
# This give us access to the state file for the foundation project.
# That makes it possible for us to create DNS entries on bocoup.org,
# which is owned by the foundation.
#
data "terraform_remote_state" "foundation" {
  backend = "s3"
  config {
    bucket = "foundation-terraform"
    key = "foundation.tfstate"
    region = "us-east-1"
    profile = "foundation"
  }
}

##
# This locates the AMI for the Ubuntu image we'd like to use on all of our VMs
# for this project.
#
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20170221"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  # Canonical
  owners = ["099720109477"]
}
