
# IAM User ecr-uploader - used by CI/CD for deploying images to ECR
# -----------------------------------------------------------------
resource "aws_iam_user" "ecr-uploader" {
  name = "ecr-uploader"
  path = "/system/"
}
resource "aws_iam_user_policy" "ecr-full-access" {
  name = "ecr-full-access"
  user = aws_iam_user.ecr-uploader.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
resource "aws_iam_access_key" "ecr-uploader" {
  user = aws_iam_user.ecr-uploader.name
}
# resource "aws_iam_user_policy_attachment" "ecr-uploader" {
#   user       = aws_iam_user.ecr-uploader.name
#   policy_arn = data.aws_iam_policy.ecr-full-access.arn
# }
