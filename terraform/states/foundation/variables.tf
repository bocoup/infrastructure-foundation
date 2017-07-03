##
# This is primarily used as a convience for tagging resources so operators who
# are looking at the web UI can easily see project delinations. It's also used
# as a prefix in places where the underlying cloud provider requires unique
# names for resources we'd otherwise like to name generically.
#
variable "name" {
  default = "foundation"
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
    key = "foundation.tfstate"
    region = "us-east-1"
    profile = "foundation"
  }
}

##
# This is the primary domain associated with this project's infrastructure.
#
variable "domain" {
  default = "bocoup.org"
}
