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

resource "aws_route53_zone" "ajl-ai" {
  name = "ajl.ai"
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

resource "aws_route53_record" "ajl-ai_A_ajl-ai" {
  zone_id = "${aws_route53_zone.ajl-ai.id}"
  type = "A"
  name = "ajl.ai"
  ttl = "1"
  records = ["${aws_instance.production.public_ip}"]
}

resource "aws_route53_record" "ajl-ai_CNAME_staging-ajl-ai" {
  zone_id = "${aws_route53_zone.ajl-ai.id}"
  type = "A"
  name = "staging"
  ttl = "1"
  records = ["${aws_instance.staging.public_ip}"]
}
