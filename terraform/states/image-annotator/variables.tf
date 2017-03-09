# These are populated by the variables.tfvars file one directory up.
variable "profile" { }
variable "region" { }
variable "key_name" { }

# Used as a prefix for tagging in many locations.
variable "name" {
  default = "image-annotator"
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

##
# Provide credentials for AWS from ~/.aws/credentials
# with the correct profile name.
#
provider "aws" {
  profile = "${var.profile}"
  region = "${var.region}"
}
