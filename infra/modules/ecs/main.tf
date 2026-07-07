# create ecs cluster 
resource "aws_ecs_cluster" "main" {
  name = "${var.environment}-ecs-cluster"
}
# add security group 
resource "aws_security_group" "ecs_sg" {

  name        = "${var.environment}-ecs-sg"

  description = "ECS Security Group"

  vpc_id = var.vpc_id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
# task definition 
resource "aws_ecs_task_definition" "nginx" {

  family = "${var.environment}-nginx"

  network_mode = "awsvpc"

  requires_compatibilities = ["FARGATE"]

  cpu = "256"

  memory = "512"

  container_definitions = jsonencode([
    {
      name = "nginx"

      image = "nginx:latest"

      essential = true

      portMappings = [
        {
          containerPort = 80
          hostPort = 80
        }
      ]
    }
  ])
}
# ECS service 
resource "aws_ecs_service" "main" {

  name = "${var.environment}-service"

  cluster = aws_ecs_cluster.main.id

  task_definition = aws_ecs_task_definition.nginx.arn

  desired_count = 1

  launch_type = "FARGATE"

  network_configuration {

    subnets = var.public_subnet_ids

    security_groups = [aws_security_group.ecs_sg.id]

    assign_public_ip = true

  }
  load_balancer {
  target_group_arn = var.target_group_arn
  container_name   = "nginx"
  container_port   = 80
  }
}