variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "subnet_cidr" {
  description = "Public subnet CIDR"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}


variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
}


variable "key_name" {
  description = "EC2 key pair"
  type        = string
}