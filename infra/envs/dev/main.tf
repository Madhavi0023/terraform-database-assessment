module "network" {
  source = "../../modules/network"

  environment = var.environment

  vpc_cidr = "10.0.0.0/16"

  public_subnet_1_cidr = "10.0.1.0/24"
  public_subnet_2_cidr = "10.0.2.0/24"

  private_subnet_1_cidr = "10.0.3.0/24"
  private_subnet_2_cidr = "10.0.4.0/24"

  availability_zone_1 = "ap-south-1a"
  availability_zone_2 = "ap-south-1b"
}
# alb module 
module "alb" {
  source = "../../modules/alb"

  environment       = var.environment
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
}
# ECS module 
module "ecs" {
  source = "../../modules/ecs"

  environment       = var.environment
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  target_group_arn  = module.alb.target_group_arn
}
# RDS module 
module "rds" {
  source = "../../modules/rds"

  environment = var.environment

  vpc_id = module.network.vpc_id

  private_subnet_ids = module.network.private_subnet_ids

  db_instance_class = var.db_instance_class

  backup_retention_period = var.backup_retention_period

  deletion_protection   = var.deletion_protection
  ecs_security_group_id = module.ecs.ecs_security_group_id

}
