provider "aws" {
  region = var.region
}

# VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

# Subnet
resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr

  tags = {
    Name = var.subnet_name
  }

  depends_on = [
    aws_vpc.main
  ]
}

# Security Group
resource "aws_security_group" "sg" {
  name   = var.sg_name
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = [
    aws_vpc.main
  ]
}

# EC2 Instance
resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = "Day5_Explicity_EC2"
  }

  depends_on = [
    aws_vpc.main,
    aws_subnet.subnet1,
    aws_security_group.sg
  ]
}