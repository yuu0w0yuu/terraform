resource "aws_route53_zone" "main" {
  name = var.domain_name
}

resource "aws_route53_record" "alb" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "alb"
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "acm_validation_alb" {
  for_each = { for dvo in aws_acm_certificate.alb.domain_validation_options : dvo.domain_name => dvo }

  zone_id = aws_route53_zone.main.zone_id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  records = [each.value.resource_record_value]
  ttl     = 60

}