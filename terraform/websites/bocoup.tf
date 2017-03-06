##
# A temporary bucket for redirecting apex bocoup.org to bocoup.com.
# This can go away when there is an actual bocoup.org website.
#
resource "aws_s3_bucket" "bocoup-org" {
  bucket = "bocoup.org"
  website {
    redirect_all_requests_to = "bocoup.com"
  }
}

##
# A DNS entry to connect apex bocoup.org to bucket above.
# This allows redirecting to bocoup.com without a server.
#
resource "aws_route53_record" "bocoup-org_A_bocoup-com" {
  zone_id = "${var.domain_zone_id}"
  type = "A"
  name = "bocoup.org"
  alias {
    name = "${aws_s3_bucket.bocoup-org.website_domain}"
    zone_id = "${aws_s3_bucket.bocoup-org.hosted_zone_id}"
    evaluate_target_health = false
  }
}

##
# Redirect www.bocoup.org to bocoup.com
#
resource "aws_route53_record" "bocoup-org_CNAME_www-bocoup-com" {
  zone_id = "${var.domain_zone_id}"
  type = "CNAME"
  name = "www"
  ttl = "1"
  records = ["bocoup.com"]
}
