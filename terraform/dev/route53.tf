
resource "aws_route53_zone" "zone" {
  name = var.domain_name
}

resource "aws_route53_record" "web" {
  zone_id = aws_route53_zone.zone.id
  name = var.domain_name
  type = "A"
  ttl = 300
  records = [aws_eip.web.public_ip]
}
resource "aws_route53_record" "web" {
  zone_id = aws_route53_zone.main.zone_id
  name = var.domain_name
  type = "A"
  ttl = 300
  records = [aws_eip.web.public_ip]
}