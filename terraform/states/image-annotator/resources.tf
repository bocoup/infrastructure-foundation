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

resource "aws_s3_bucket" "main" {
  acl = "public-read"
  bucket = "image-annotator-assets"
  policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::image-annotator-assets",
        "arn:aws:s3:::image-annotator-assets/*"
      ]
    }
  ]
}
EOF
}
