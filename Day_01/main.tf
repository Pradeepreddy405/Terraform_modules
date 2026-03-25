terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"

  # Global tags (applied to all resources)
  default_tags {
    tags = {
      Environment = "dev"
      Project     = "terraform-demo"
      Owner       = "devopsUser"
    }
  }
}

# VPC Resource
resource "aws_vpc" "day1_vpc" {
  cidr_block = "10.0.0.0/16"

  # Resource-specific tags
  tags = {
    Name = "day1_vpc_dev"
  }
}

# Internet gateway 
resource "aws_internet_gateway" "Day1_Internet_gateway" {
  vpc_id = aws_vpc.day1_vpc.id

  tags = {
    Name = "Day1_Internet_gateway"
  }
}

# Public Subnet
resource "aws_subnet" "Day1_public_subnet" {
  vpc_id                  = aws_vpc.day1_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Day1_public_subnet"
  }
}

resource "aws_route_table" "day1_public_rt" {
  vpc_id = aws_vpc.day1_vpc.id

  tags = {
    Name = "day1_public_rt"
  }
}

resource "aws_route" "day1_internet_access_routes" {
  route_table_id         = aws_route_table.day1_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.Day1_Internet_gateway.id

}

resource "aws_route_table_association" "day1_public_association_to_subnet" {
  subnet_id      = aws_subnet.Day1_public_subnet.id
  route_table_id = aws_route_table.day1_public_rt.id

}

resource "aws_security_group" "day1_sg" {
  name        = "day1_sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.day1_vpc.id

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
    Name = "day1_sg"
  }
}
resource "aws_instance" "day1_ec2" {
  ami                         = "ami-05d2d839d4f73aafb" # Ubuntu (ap-south-1)
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.Day1_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.day1_sg.id]
  associate_public_ip_address = true

  key_name                    = "terraform_day1"
  user_data_replace_on_change = true

  user_data = <<-EOF
              #!/bin/bash
              exec > /var/log/user-data.log 2>&1

              sleep 30

              sudo apt-get update -y
              sudo apt-get install -y nginx

              sudo systemctl start nginx
              sudo systemctl enable nginx

              # Remove default page
              rm -f /var/www/html/index.nginx-debian.html


              echo "<h1>Terraform Nginx Server</h1>" > /var/www/html/index.html
              EOF
  tags = {
    Name = "day1_ec2"
  }
}
