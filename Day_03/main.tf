terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket         = "terra-remote-backend-devops"
    key            = "day3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
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

# ---------------- VPC ----------------
resource "aws_vpc" "day3_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "day3_vpc_dev"
  }
}

# ---------------- Subnet ----------------
resource "aws_subnet" "day3_public_subnet" {
  vpc_id                  = aws_vpc.day3_vpc.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "day3_public_subnet"
  }
}

# ---------------- Internet Gateway ----------------
resource "aws_internet_gateway" "day3_igw" {
  vpc_id = aws_vpc.day3_vpc.id

  tags = {
    Name = "day3_igw"
  }
}

# ---------------- Route Table ----------------
resource "aws_route_table" "day3_rt" {
  vpc_id = aws_vpc.day3_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.day3_igw.id
  }

  tags = {
    Name = "day3_rt"
  }
}

# ---------------- Route Table Association ----------------
resource "aws_route_table_association" "day3_rta" {
  subnet_id      = aws_subnet.day3_public_subnet.id
  route_table_id = aws_route_table.day3_rt.id
}

# ---------------- Security Group ----------------
resource "aws_security_group" "day3_sg" {
  name        = "day3_sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.day3_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # tighten in real world
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
    Name = "day3_sg"
  }
}

# ---------------- EC2 ----------------
resource "aws_instance" "day3_ec2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.day3_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.day3_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  tags = {
    Name = var.instance_name
  }
}