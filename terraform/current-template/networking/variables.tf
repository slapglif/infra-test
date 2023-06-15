variable "project" {
  description = "Name to be used for all resources as identifier"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "vpc_name_tag" {
  description = "VPC name tag"
  type        = string
}

variable "availability_zones_count" {
  description = "The amount of AZs."
  type        = number
}

variable "subnet_cidr_bits" {
  description = "The number of subnet bits for the CIDR. For example, specifying a value 8 for this parameter will create a CIDR with a mask of /24."
  type        = number
  default     = "3"
}
