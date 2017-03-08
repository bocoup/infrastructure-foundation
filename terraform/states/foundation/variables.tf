# These are populated by the variables.tfvars file one directory up.
variable "profile" { }
variable "region" { }

# Used as a prefix for tagging in many locations.
variable "name" {
  default = "foundation"
}

# The primary domain associated with this infrastructure.
variable "domain" {
  default = "bocoup.org"
}

##
# Provide credentials for AWS from ~/.aws/credentials
# with the correct profile name.
#
provider "aws" {
  profile = "${var.profile}"
  region = "${var.region}"
}
