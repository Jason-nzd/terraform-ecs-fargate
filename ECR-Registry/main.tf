resource "aws_ecr_repository" "my_ecr" {
  name                 = var.ecr_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "untagged_expiry" {
  repository = aws_ecr_repository.my_ecr.name

  policy = <<EOF
  {
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than ${var.image_expiry_days} days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": ${var.image_expiry_days}
            },
            "action": {
                "type": "expire"
            }
        }
    ]
  }
  EOF
}
