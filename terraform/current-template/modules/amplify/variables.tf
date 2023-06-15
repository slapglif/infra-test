variable "amplify_app_name" {
  description = "Amplify application name"
  type        = string
  default     = var.amplify_app_name
}

variable "amplify_bitbucket_client_id" {
  description = "Bitbucket client id"
  type        = string
  default     = var.amplify_bitbucket_client_id
}

variable "amplify_bitbucket_client_secret" {
  description = "Bitbucket client secret"
  type        = string
  default     = var.amplify_bitbucket_client_secret
}

variable "amplify_build_spec_file_path" {
  description = "Path for amplify buildspec file"
  type        = string
  default     = var.amplify_build_spec_file_path
}

variable "amplify_role_policies_file_path" {
  description = "Path for amplify role policies file"
  type        = string
  default     = var.amplify_role_policies_file_path
}
