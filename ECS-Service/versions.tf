terraform {
  required_version = ">= 1.8.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.50.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}
