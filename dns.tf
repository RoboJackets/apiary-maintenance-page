resource "aws_route53_zone" "zone" {
  name = var.domain_name
}

resource "aws_route53_health_check" "target_server" {
  fqdn              = var.domain_name
  ip_address        = var.target_server_ip
  port              = 443
  type              = "HTTPS"
  failure_threshold = 5
  request_interval  = 30
  resource_path     = "/ping"
  regions           = var.aws_regions

  tags = {
    Name = "apiary-target-server"
  }
}

resource "aws_route53_record" "target_server" {
  zone_id = aws_route53_zone.zone.zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = "300"
  records = [
    var.target_server_ip
  ]
  set_identifier = "target-server"

  failover_routing_policy {
    type = "PRIMARY"
  }

  health_check_id = aws_route53_health_check.target_server.id
}

resource "aws_route53_record" "cloudfront" {
  zone_id        = aws_route53_zone.zone.zone_id
  name           = var.domain_name
  type           = "A"
  set_identifier = "maintenance-page"

  alias {
    name                   = aws_cloudfront_distribution.cloudfront.domain_name
    zone_id                = "Z2FDTNDATAQYW2" # https://docs.aws.amazon.com/Route53/latest/APIReference/API_AliasTarget.html
    evaluate_target_health = false
  }

  failover_routing_policy {
    type = "SECONDARY"
  }
}
