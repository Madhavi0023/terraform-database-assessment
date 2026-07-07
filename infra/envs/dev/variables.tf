variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "environment" {
  description = "Environment Name"
  type        = string
}
variable "db_instance_class" {
  description = "RDS Instance Class"
  type        = string
}

variable "backup_retention_period" {
  description = "RDS Backup Retention"
  type        = number
}

variable "deletion_protection" {
  description = "Enable Deletion Protection"
  type        = bool
}