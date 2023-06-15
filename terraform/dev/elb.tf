
resource "aws_elb" "web" {
  name = "web-elb"
  subnets = aws_subnet.public.*.id
  security_groups = [aws_security_group.web-elb.id]
}

resource "aws_elb_attachment" "web" {
  count = 3
  elb = aws_elb.web.id
  instance = aws_instance.web.*.id[count.index]
}
resource "aws_elb" "web_elb" {
  name = "web-elb"
  security_groups = [aws_security_group.web_security_group.id]
  subnets = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:80/"
  }
}
