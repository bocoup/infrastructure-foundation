# Used as a prefix for tagging in many locations.
variable "name" {
  default = "ajl"
}

# This is the network all of our services are hosted in.
variable "vpc_cidr" {
  default = "10.100.0.0/16"
}

# This is all of the availability zones we will create subnets for
variable "azs" {
  type = "list"
  default = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c"
  ]
}

variable "subnet_cidr_blocks" {
  type = "list"
  default = [
    "10.100.0.0/24",
    "10.100.1.0/24",
    "10.100.2.0/24"
  ]
}

provider "aws" {
  profile = "foundation"
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "foundation-terraform"
    key = "ajl.tfstate"
    region = "us-east-1"
    profile = "foundation"
  }
}

data "terraform_remote_state" "foundation" {
  backend = "s3"
  config {
    bucket = "foundation-terraform"
    key = "foundation.tfstate"
    region = "us-east-1"
    profile = "foundation"
  }
}

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
