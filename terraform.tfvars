# A name (used as a prefix in many places) for this infrastructure.
name = "bocoup-foundation"

# The primary domain associated with this infrastructure.
domain = "bocoup.org"

# The AWS region where this infrastructure resides.
aws_region = "us-east-1"

# This is the name of the default keypair key to use for all instances.
key_name = "default"

# This is the network all of our services are hosted in.
vpc_cidr = "10.100.0.0/16"

# This is all of the availability zones we will create subnets for
azs = [
  "us-east-1a",
  "us-east-1b",
  "us-east-1c"
]

# Subnets to define within the VPC, one for each AZ.
subnet_cidrs = [
  "10.100.0.0/24",
  "10.100.1.0/24",
  "10.100.2.0/24"
]
