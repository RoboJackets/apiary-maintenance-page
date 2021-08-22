variable "domain_name" {
  type        = string
  description = "The domain name to manage"
}

variable "acm_certificate_arn" {
  type        = string
  description = "The ARN of the ACM certificate to assign to the CloudFront distribution"
}

variable "target_server_ip" {
  type        = string
  description = "The primary Apiary server to monitor and route traffic to"
}

variable "aws_regions" {
  type        = list(string)
  description = "The regions from which health checks should originate"
}
