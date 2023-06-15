
resource "aws_eip" "web" {
  vpc = true
  tags = {
    Name = "web"
  }
}
resource "aws_eip_association" "web" {
  instance_id = aws_instance.web.id
  allocation_id = aws_eip.web.id
}