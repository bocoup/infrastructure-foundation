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

module "vpc" {
  source = "../../modules/aws/vpc"
  name = "${var.name}"
  cidr = "${var.vpc_cidr}"
}

module "subnet" {
  source = "../../modules/aws/subnet"
  name = "${var.name}"
  azs = "${var.azs}"
  vpc_id = "${module.vpc.id}"
  cidr_blocks = "${var.subnet_cidr_blocks}"
}
