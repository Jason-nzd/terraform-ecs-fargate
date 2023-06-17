# ECS Task Execution Role
# -----------------------
resource "aws_iam_role" "ecs-task-execution" {
  name               = "ECS-TaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  inline_policy {} # Ensure no extra inline policies
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution" {
  role = aws_iam_role.ecs-task-execution.name
  # Use AWS Managed Policy - AmazonECSTaskExecutionRolePolicy
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
