terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.66.1"
    }
  }
  backend "s3" {
  }
}

module "amplify_dev_application" {
  source                          = "./modules/amplify"
  amplify_app_name                = "my-music-auto-staging"
  amplify_build_spec_file_path    = file("${path.module}/buildspec.yml")
  amplify_role_policies_file_path = file("${path.module}/amplify_role_policies.json")
  amplify_bitbucket_client_id     = var.amplify_bitbucket_client_id
  amplify_bitbucket_client_secret = var.amplify_bitbucket_client_secret
}

locals {
  vpc_cidr             = "10.0.0.0/16"
  keycloak_dev_db_name = "keycloak_dev"
}

module "keycloak_dev_networking" {
  source                   = "./modules/networking"
  availability_zones_count = 3
  project                  = "mymusic"
  vpc_cidr                 = local.vpc_cidr
  vpc_name_tag             = "mymusic-keycloak-dev"
}

module "keycloak_dev_application" {
  source                  = "./modules/keycloak"
  keycloak_ami_id         = "ami-053b0d53c279acc90"
  keycloak_instance_type  = "t3.micro"
  environment_tag_value   = "Development"
  name_tag_value          = "Keycloak development instance"
  public_key_value        = var.keycloak_ec2_public_key
  key_name_value          = "keycloak-key"
  private_key_path        = file("${path.module}/keys/dev/id_rsa")
  keycloak_admin          = var.keycloak_dev_admin
  keycloak_admin_password = var.keycloak_dev_admin_password

  keycloak_subnet_id = module.keycloak_dev_networking.public_subnet_ids[0]
  keycloak_vpc_id    = module.keycloak_dev_networking.vpc_id

  keycloak_container_name = "keycloak-dev"
  keycloak_db_endpoint    = module.keycloak_dev_db.db_instance_endpoint
  keycloak_db_name        = local.keycloak_dev_db_name
  keycloak_db_user        = var.keycloak_dev_db_user
  keycloak_db_password    = var.keycloak_dev_db_password
}

module "keycloak_dev_db" {
  source                = "terraform-aws-modules/rds/aws"
  version               = "5.9.0"
  identifier            = "keycloak-dev-db"
  engine                = "postgres"
  engine_version        = "10"
  family                = "postgres10"
  major_engine_version  = "10"
  instance_class        = "db.t3.micro"
  allocated_storage     = 5
  max_allocated_storage = 10

  #By default this variable is 'true' and password value provided is being ignored
  create_random_password = false

  db_name  = local.keycloak_dev_db_name
  username = var.keycloak_dev_db_user
  password = var.keycloak_dev_db_password
  port     = 5432
  multi_az = false

  db_subnet_group_name   = aws_db_subnet_group.keycloak_dev_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.keycloak_dev_db_sg.id]
  publicly_accessible    = false
}

resource "aws_db_subnet_group" "keycloak_dev_db_subnet_group" {
  description = "Database subnet group for dev Keycloak"
  subnet_ids  = module.keycloak_dev_networking.private_subnet_ids
}

resource "aws_security_group" "keycloak_dev_db_sg" {
  name        = "keycloak-dev-db-sg"
  description = "Security group for Keycloak Dev DB"
  vpc_id      = module.keycloak_dev_networking.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
