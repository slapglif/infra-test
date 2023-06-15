variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_provider_access_key" {
  description = "Access key for AWS terraform provider"
  type        = string
}

variable "aws_provider_secret_key" {
  description = "Secret key for AWS terraform provider"
  type        = string
}

variable "amplify_bitbucket_client_id" {
  description = "Bitbucket client id"
  type        = string
}

variable "amplify_bitbucket_client_secret" {
  description = "Bitbucket client secret"
  type        = string
}

variable "keycloak_ec2_public_key" {
  description = "Keycloak EC2 public key value"
  type        = string
}

variable "keycloak_dev_admin" {
  description = "Keycloak dev admin user"
  type        = string
}

variable "keycloak_dev_admin_password" {
  description = "Keycloak dev admin password"
  type        = string
}

variable "keycloak_dev_db_user" {
  description = "Keycloak dev db user"
  type        = string
}

variable "keycloak_dev_db_password" {
  description = "Keycloak dev db password"
  type        = string
}
