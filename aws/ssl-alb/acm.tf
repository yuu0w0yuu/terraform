resource "aws_acm_certificate" "alb" {
  domain_name       = "alb.${var.domain_name}"
  validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "alb" {
  certificate_arn         = aws_acm_certificate.alb.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_validation_alb : record.fqdn]
}