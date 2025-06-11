variable "cidr_block_public" {
  description = "Public subnet CIDR block"
  type        = string
  default     = "10.0.0.0/25"
}

variable "cidr_block_private" {
  description = "Private subnet CIDR block"
  type        = string
  default     = "10.0.0.128/25"
}

variable "availability_zone" {
  description = "Availability zone"
  type        = string
  default     = "ap-south-1a"
}

variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "ap-south-1"
}