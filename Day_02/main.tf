terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}


provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Environment = "dev"
      Project     = "terraform-demo"
      Owner       = "devopsUser"
    }
  }
}
resource "aws_vpc" "day2_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "day2_vpc_dev"
  }
}

resource "aws_subnet" "Day2_public_subnet" {
  vpc_id                  = aws_vpc.day2_vpc.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "Day2_public_subnet"
  }
}

resource "aws_security_group" "day2_sg" {
  name        = "day2_sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.day2_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # open to world (for testing only)
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "day2_sg"
  }
}

resource "aws_instance" "Day2_ec2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.Day2_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.day2_sg.id]
  associate_public_ip_address = true

  key_name = var.key_name
  


}