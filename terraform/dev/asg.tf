
resource "aws_launch_configuration" "web_launch_configuration" {
  name_prefix = "web-lc-"
  image_id = var.ami_id
  instance_type = var.instance_type
  security_groups = [aws_security_group.web_security_group.id]
  user_data = file("userdata.sh")
}

resource "aws_autoscaling_group" "web_autoscaling_group" {
  name_prefix = "web-asg-"
  launch_configuration = aws_launch_configuration.web_launch_configuration.id
  min_size = var.asg_min_size
  max_size = var.asg_max_size
  desired_capacity = var.asg_desired_capacity
  health_check_grace_period = var.asg_health_check_grace_period
  health_check_type = var.asg_health_check_type
  vpc_zone_identifier = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
}
