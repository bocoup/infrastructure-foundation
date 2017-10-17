##
# DNS zone for primary domain.
#
resource "aws_route53_zone" "main" {
  name = "${var.domain}."
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route53_record" "bocoup-org_MX_bocoup-com" {
  zone_id = "${aws_route53_zone.main.id}"
  name = "${var.domain}"
  type = "MX"
  ttl = "1"
  records = [
    "20 alt1.aspmx.l.google.com.",
    "20 alt2.aspmx.l.google.com.",
    "30 aspmx2.googlemail.com.",
    "30 aspmx3.googlemail.com.",
    "30 aspmx4.googlemail.com.",
    "30 aspmx5.googlemail.com.",
    "10 aspmx.l.google.com."
  ]
}
