# Which AWS profile to use for authentication
variable "profile" {
  default = "foundation"
}
variable "region" {
  default = "us-east-1"
}

# Used as a prefix for tagging in many locations.
variable "name" {
  default = "foundation"
}

# The primary domain associated with this infrastructure.
variable "domain" {
  default = "bocoup.org"
}

provider "aws" {
  profile = "foundation"
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "foundation-terraform"
    key = "foundation.tfstate"
    region = "us-east-1"
    profile = "foundation"
  }
}
