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
# This is the network all of our services are hosted in. Each VPC is an isolated
# network for a project to live in.
#
variable "vpc_cidr" {
  default = "10.100.0.0/16"
}

##
# This is all the networks we'll create subnets for. If we want to provide
# high availability for the services we host in this project, we would ideally
# put an instance in each one and load balance between them.
#
variable "subnet_cidr_blocks" {
  type = "list"
  default = [
    "10.100.0.0/24",
    "10.100.1.0/24",
    "10.100.2.0/24"
  ]
}

##
# Each subnet lives in an availability zone. When subnets are created we match
# the index of this array with the array of subnets.
#
# TODO: determine if terraform has better support for map primitives such that
#       this separation is no longer needed.
#
variable "azs" {
  type = "list"
  default = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c"
  ]
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
