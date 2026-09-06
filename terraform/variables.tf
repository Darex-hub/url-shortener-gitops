variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "key_name" {
  description = "EC2 key_name"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed for SSH"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "aws_region" {
  description = "Aws region to deploy resource"
  type        = string
}