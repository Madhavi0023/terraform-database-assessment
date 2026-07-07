resource "aws_security_group" "rds_sg" {
  name   = "${var.environment}-rds-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    security_groups = [var.ecs_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# db subnet group 
resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = var.private_subnet_ids
}
# rds instance 
resource "aws_db_instance" "postgres" {

  identifier = "${var.environment}-postgres"

  engine = "postgres"

  engine_version = "16"

  instance_class = var.db_instance_class

  allocated_storage = 20

  username = "postgres"

  password = "Password@123"

  db_name = "hoteldb"

  skip_final_snapshot = true

  publicly_accessible = false

  db_subnet_group_name = aws_db_subnet_group.main.name

  vpc_security_group_ids = [
    aws_security_group.rds_sg.id
  ]

  backup_retention_period = var.backup_retention_period

  deletion_protection = var.deletion_protection
}
