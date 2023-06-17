output "ecr_repository_uri" {
  value = "${aws_ecr_repository.my_ecr.repository_url}:latest"
}

output "docker-login-cmd" {
  value = "aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${split("/", aws_ecr_repository.my_ecr.repository_url)[0]}"
}

output "docker-tag-cmd" {
  value = "docker tag ${var.image_name}:latest ${aws_ecr_repository.my_ecr.repository_url}:latest"
}

output "docker-push-cmd" {
  value = "docker push ${aws_ecr_repository.my_ecr.repository_url}"
}
