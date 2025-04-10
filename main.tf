provider "aws" {
  region = var.region
}

resource "aws_ecs_cluster" "this" {
  name = "simple-fargate-cluster"
}

resource "aws_ecs_task_definition" "this" {
  family                   = "fargate-task"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  execution_role_arn       = var.execution_role_arn

  container_definitions = &lt;&lt;EOF
[
  {
    "name": "hello-world",
    "image": "nginx",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ],
    "essential": true
  }
]
EOF
}

resource "aws_ecs_service" "this" {
  name            = "simple-fargate-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnets
    security_groups  = [var.security_group_id]
    assign_public_ip = true
  }
}
