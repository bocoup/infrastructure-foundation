resource "aws_route53_zone" "fightbias-org" {
  name = "fightbias.org"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route53_zone" "fightbias-io" {
  name = "fightbias.io"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route53_record" "fightbias-io_A_fightbias-io" {
  zone_id = "${aws_route53_zone.fightbias-io.id}"
  type = "A"
  name = "fightbias.io"
  ttl = "1"
  records = ["${aws_instance.production.public_ip}"]
}

resource "aws_route53_record" "fightbias-org_A_fightbias-org" {
  zone_id = "${aws_route53_zone.fightbias-org.id}"
  type = "A"
  name = "fightbias.org"
  ttl = "1"
  records = ["${aws_instance.production.public_ip}"]
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
