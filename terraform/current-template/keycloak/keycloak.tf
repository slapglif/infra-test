resource "aws_instance" "keycloak_instance" {
  ami           = var.keycloak_ami_id
  instance_type = var.keycloak_instance_type

  vpc_security_group_ids = [aws_security_group.keycloak_sg.id]

  subnet_id = var.keycloak_subnet_id

  key_name = aws_key_pair.keycloak-key.key_name

  tags = {
    Name        = var.name_tag_value
    Environment = var.environment_tag_value
  }

  user_data_base64 = base64encode(templatefile("${path.module}/install.sh", {
    keycloak_admin          = var.keycloak_admin,
    keycloak_admin_password = var.keycloak_admin_password
    keycloak_container_name = var.keycloak_container_name
    keycloak_db_endpoint    = var.keycloak_db_endpoint
    keycloak_db_name        = var.keycloak_db_name
    keycloak_db_user        = var.keycloak_db_user
    keycloak_db_password    = var.keycloak_db_password
  }))

  provisioner "file" {
    #TODO: make ssl keys path configurable
    source      = "${path.module}/ssl-keys-dev"
    destination = "/home/ubuntu"

    connection {
      type        = "ssh"
      host        = aws_instance.keycloak_instance.public_ip
      user        = "ubuntu"
      private_key = var.private_key_path
      insecure    = true
    }
  }
}

resource "aws_key_pair" "keycloak-key" {
  key_name   = var.key_name_value
  public_key = var.public_key_value
}
