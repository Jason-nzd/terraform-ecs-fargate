variable "aws_region" {
  description = "Region to place all AWS resources"
  type        = string
  default     = "ap-southeast-2"
}

variable "ecr_name" {
  description = "Name of ECR registry"
  type        = string
  # Should be all lowercase, hyphens, underscores, or numbers. No spaces allowed"
  default = "my_ecr"
}

variable "image_name" {
  description = "Name of container image. Is used for sample output docker tag command."
  type        = string
  default     = "my-image"
}

variable "image_expiry_days" {
  description = "Number of days until untagged images are expired"
  type        = number
  default     = 1
}
