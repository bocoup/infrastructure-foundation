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
