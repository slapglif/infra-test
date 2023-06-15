
resource "aws_security_group" "rds" {
  name_prefix = "rds"
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "rds"
  }
}

resource "aws_security_group" "rds" {
  name_prefix = "rds-"
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "rds-security-group"
  }
}

resource "aws_security_group" "rds_security_group" {
  name_prefix = "rds_security_group"
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "rds-security-group"
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name_prefix = "rds_subnet_group"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  tags = {
    Name = "rds-subnet-group"
  }
}

resource "aws_db_subnet_group" "web_db_subnet_group" {
  name = "web-db-subnet-group"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
}

resource "aws_db_instance" "web_db_instance" {
  name = "web-db-instance"
  engine = "mysql"
  engine_version = "5.7"
  instance_class = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  storage_type = var.db_storage_type
  db_subnet_group_name = aws_db_subnet_group.web_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_security_group.id]
  username = var.db_username
  password = var.db_password
  parameter_group_name = "default.mysql5.7"
}
