variable "aws_region" {
  description = "Region to place all AWS resources"
  type        = string
  default     = "ap-southeast-2"
}

variable "project_name" {
  description = "This name will be prefixed or suffixed to most resource names"
  type        = string
  default     = "node"
}

variable "ecr_repository_uri" {
  description = "The image uri of the image hosted in ECR"
  type        = string
}

variable "vpc-full-cidr" {
  description = "CIDR range for VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "num_subnets" {
  description = "Number of subnets to place into each public/private tier"
  type        = number
  default     = 3
}
