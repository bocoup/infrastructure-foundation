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

resource "aws_s3_bucket" "backup" {
  bucket = "image-annotator-backup"
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

resource "aws_security_group" "web" {
  vpc_id = "${module.vpc.id}"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "production" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.small"
  key_name = "default"
  subnet_id = "${element(module.subnet.ids, 0)}"
  vpc_security_group_ids = [
    "${aws_security_group.web.id}",
  ]
  tags {
    "Name" = "${var.name}-production"
  }
  iam_instance_profile = "${aws_iam_instance_profile.backup.name}"
}

resource "aws_instance" "staging" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.small"
  key_name = "default"
  subnet_id = "${element(module.subnet.ids, 0)}"
  vpc_security_group_ids = [
    "${aws_security_group.web.id}",
  ]
  tags {
    "Name" = "${var.name}-staging"
  }
  iam_instance_profile = "${aws_iam_instance_profile.backup.name}"
}

resource "aws_route53_record" "ajl-bocoup-org_A_ajl-bocoup-org" {
  zone_id = "${data.terraform_remote_state.foundation.domain_zone_id}"
  type = "A"
  name = "ajl"
  ttl = "1"
  records = ["${aws_instance.production.public_ip}"]
}

resource "aws_route53_record" "ajl-bocoup-org_A_ajl-staging-bocoup-org" {
  zone_id = "${data.terraform_remote_state.foundation.domain_zone_id}"
  type = "A"
  name = "ajl-staging"
  ttl = "1"
  records = ["${aws_instance.staging.public_ip}"]
}

resource "aws_iam_role" "backup" {
  name = "${var.name}-backup"
  path = "/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {"AWS": "*"},
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "backup" {
  name = "${var.name}-backup"
  roles = ["${aws_iam_role.backup.name}"]
  policy_arn = "${aws_iam_policy.backup.arn}"
}

resource "aws_iam_instance_profile" "backup" {
  name = "${var.name}-backup"
  roles = ["${aws_iam_role.backup.name}"]
}


resource "aws_iam_policy" "backup" {
  name = "${var.name}-backup"
  description = "Rights for backup files"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListAllMyBuckets",
      "Resource": "arn:aws:s3:::*"
    },
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.backup.id}*"
      ]
    }
  ]
}
EOF
}

# This user owns the access keys that allow local devs to load production backups
resource "aws_iam_user" "backup" {
  name = "${var.name}-backup"
}

resource "aws_iam_user_policy_attachment" "backup" {
  user = "${aws_iam_user.backup.name}"
  policy_arn = "${aws_iam_policy.backup.arn}"
}
