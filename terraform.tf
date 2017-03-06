variable "name" { }
variable "domain" { }
variable "aws_region" { }
variable "vpc_cidr" { }
variable "azs" { type = "list" }
variable "key_name" { }
variable "subnet_cidrs" { type = "list" }

##
# Provide credentials for AWS from ~/.aws/credentials
# with the correct profile name.
#
provider "aws" {
  profile = "${var.name}"
  region = "${var.aws_region}"
}

##
# AMI for Ubuntu 16
#
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20170303"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  # Canonical
  owners = ["099720109477"]
}

##
# Network for our entire infrastructure.
#
module "vpc" {
  source = "./terraform/modules/aws/vpc"
  name = "${var.name}"
  cidr = "${var.vpc_cidr}"
}

##
# Subnets within our network.
#
module "subnet" {
  source = "./terraform/modules/aws/subnet"
  name = "${var.name}-public"
  azs = "${var.azs}"
  vpc_id = "${module.vpc.id}"
  cidrs = "${var.subnet_cidrs}"
}

##
# DNS zone for primary domain.
#
resource "aws_route53_zone" "main" {
  name = "${var.domain}"
  lifecycle {
    prevent_destroy = true
  }
}

##
# All Bocoup Foundation Inc webites.
#
module "websites" {
  source = "./terraform/websites"
  domain = "${var.domain}"
  domain_zone_id = "${aws_route53_zone.main.id}"
}

##
# All Bocoup Foundation Inc services.
#
module "services" {
  source = "./terraform/services"
  domain = "${var.domain}"
  domain_zone_id = "${aws_route53_zone.main.id}"
}
