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

resource "aws_iam_instance_profile" "backup" {
  name = "${var.name}-backup"
  role = "${aws_iam_role.backup.name}"
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

resource "aws_iam_role_policy_attachment" "backup" {
  role = "${aws_iam_role.backup.id}"
  policy_arn = "${aws_iam_policy.backup.arn}"
}

resource "aws_iam_user_policy_attachment" "backup" {
  user = "${aws_iam_user.backup.name}"
  policy_arn = "${aws_iam_policy.backup.arn}"
}
