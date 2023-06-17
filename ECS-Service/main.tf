# ECS Cluster
resource "aws_ecs_cluster" "cluster" {
  name = "${var.project_name}-cluster"
}
resource "aws_ecs_cluster_capacity_providers" "fargate" {
  cluster_name = aws_ecs_cluster.cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

# ECS Task Definition
resource "aws_ecs_task_definition" "task" {
  family = "${var.project_name}-task-definition"
  container_definitions = jsonencode([
    {
      name      = "${var.project_name}-task"
      image     = var.ecr_repository_uri
      essential = true
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = var.container_web_port
          hostPort      = var.container_web_port
        }
      ]
    }
  ])
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs-task-execution.arn
}

# ECS Service
resource "aws_ecs_service" "app_service" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  launch_type     = "FARGATE"
  desired_count   = 3
  # iam_role        = aws_iam_role.ecs-task-execution.arn
  # depends_on      = [aws_iam_role.ecs-task-execution]

  load_balancer {
    target_group_arn = aws_lb_target_group.web.arn
    container_name   = "${var.project_name}-task"
    container_port   = var.container_web_port
  }

  network_configuration {
    subnets          = [aws_subnet.public[0].id, aws_subnet.public[1].id] # todo fix array
    assign_public_ip = true
    security_groups  = [aws_security_group.web-server.id]
  }
}

# Application Load Balancer
resource "aws_lb" "web" {
  name               = "${var.project_name}-load-balancer"
  load_balancer_type = "application"
  subnets            = [aws_subnet.public[0].id, aws_subnet.public[1].id]
  security_groups    = [aws_security_group.web-server.id]
}

# Load Balancer Target Group
resource "aws_lb_target_group" "web" {
  name        = "${var.project_name}-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id
}

# Load Balancer Listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.web.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}
