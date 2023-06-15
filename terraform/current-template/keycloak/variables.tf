variable "keycloak_ami_id" {
  description = "Keycloak AMI id"
  type        = string
}

variable "keycloak_instance_type" {
  description = "Keycloak EC2 instance type"
  type        = string
}

variable "key_name_value" {
  description = "Public key name"
  type        = string
}

variable "public_key_value" {
  description = "Public key material"
  type        = string
}

variable "name_tag_value" {
  description = "Name tag value"
  type        = string
}
variable "environment_tag_value" {
  description = "Environment tag value"
  type        = string
}

variable "private_key_path" {
  description = "Path to private key for keycloak EC2 ssh connection"
  type        = string
}

variable "keycloak_admin" {
  description = "Username for keycloak admin"
  type        = string
}

variable "keycloak_admin_password" {
  description = "Keycloak admin password"
  type        = string
}

variable "keycloak_container_name" {
  description = "Keycloak container name"
  type        = string
}

variable "keycloak_db_endpoint" {
  description = "Keycloak db endpoint"
  type        = string
}

variable "keycloak_db_name" {
  description = "Keycloak db name"
  type        = string
}

variable "keycloak_db_user" {
  description = "Keycloak db user"
  type        = string
}

variable "keycloak_db_password" {
  description = "Keycloak db password"
  type        = string
}

variable "keycloak_vpc_id" {
  description = "Keycloak VPC id"
  type        = string
}

variable "keycloak_subnet_id" {
  description = "Keycloak subnet id"
  type        = string
}
