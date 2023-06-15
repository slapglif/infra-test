
resource "aws_instance" "web" {
  count = 3
  ami = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name = "my-key-pair"
  subnet_id = aws_subnet.private[count.index].id
  vpc_security_group_ids = [aws_security_group.web.id]
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World!" > index.html
              nohup python -m SimpleHTTPServer 80 &
              EOF
}
resource "aws_instance" "web" {
  ami = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.web-elb.id]
  subnet_id = aws_subnet.dev.id
  key_name = var.key_name
  user_data = file("${path.module}/userdata.sh")
  tags = {
    Name = "web"
  }
}
resource "aws_instance" "web" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.web.id]
  subnet_id = aws_subnet.web.id
  associate_public_ip_address = true
  tags = {
    Name = "web"
  }
}
resource "aws_instance" "web" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.web.id]
  user_data = file("./userdata.sh")

  tags = {
    Name = var.name_prefix
  }
}
resource "aws_eip" "web" {
  vpc = true
}

resource "aws_eip_association" "web" {
  instance_id = aws_instance.web.id
  allocation_id = aws_eip.web.id
}
resource "aws_instance" "web" {
  ami = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.web.id]
  subnet_id = aws_subnet.web.id
  associate_public_ip_address = true
  key_name = var.key_name
  user_data = file("${path.module}/userdata.sh")
}
resource "aws_eip" "web" {
  vpc = true
}

resource "aws_eip_association" "web" {
  instance_id = aws_instance.web.id
  allocation_id = aws_eip.web.id
}
resource "aws_instance" "web" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.web_http.id]
  subnet_id = var.subnet_id
  associate_public_ip_address = true
  tags = {
    Name = "web"
  }
  iam_instance_profile = aws_iam_instance_profile.web.name
}

resource "aws_eip" "web" {
  vpc = true
}

resource "aws_eip_association" "web" {
  instance_id = aws_instance.web.id
  allocation_id = aws_eip.web.id
}

resource "aws_security_group" "web_http" {
  name_prefix = "web_http"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "web_http"
  }
}

resource "aws_instance" "web" {
  ami = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name = "web-key"
  vpc_security_group_ids = [aws_security_group.web_http.id]
  subnet_id = aws_subnet.web.id
  associate_public_ip_address = true
  tags = {
    Name = "web"
  }
  iam_instance_profile = aws_iam_instance_profile.web.id
}

resource "aws_eip" "web" {
  vpc = true
}

resource "aws_eip_association" "web" {
  instance_id = aws_instance.web.id
  allocation_id = aws_eip.web.id
}

resource "aws_iam_instance_profile" "web" {
  name = "web-instance-profile"
  role = aws_iam_role.web.id
}

resource "aws_security_group" "web_http" {
  name_prefix = "web-http-"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "web-http-security-group"
  }
}

resource "aws_instance" "web" {
  ami = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name = "mykey"
  vpc_security_group_ids = [aws_security_group.web_http.id]
  subnet_id = aws_subnet.web.id
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.web_instance_profile.name
  tags = {
    Name = "web-instance"
  }
}

resource "aws_iam_instance_profile" "web_instance_profile" {
  name = "web-instance-profile"
  role = aws_iam_role.web_instance_role.name
}

resource "aws_iam_role" "web_instance_role" {
  name = "web-instance-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_security_group" "web_security_group" {
  name_prefix = "web-security-group-"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-http-security-group"
  }
}

resource "aws_instance" "web_instance" {
  ami = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  key_name = "web-instance-key"
  vpc_security_group_ids = [aws_security_group.web_security_group.id]
  iam_instance_profile = aws_iam_instance_profile.web_instance_profile.name
  tags = {
    Name = "web-instance"
  }
}

resource "aws_eip" "web_eip" {
  vpc = true
  tags = {
    Name = "web-eip"
  }
}

resource "aws_eip_association" "web_eip_association" {
  instance_id = aws_instance.web_instance.id
  allocation_id = aws_eip.web_eip.id
}

resource "aws_instance" "web_instance" {
  ami = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name = "my_key_pair"
  vpc_security_group_ids = [aws_security_group.web_security_group.id]
  subnet_id = aws_subnet.public_subnet_1.id
  tags = {
    Name = "web-instance"
  }
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y apache2
              sudo systemctl start apache2
              sudo systemctl enable apache2
              EOF
}
