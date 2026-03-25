output "ec2_public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.Day2_ec2.public_ip
}

output "ec2_instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.Day2_ec2.id
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.day2_vpc.id
}

output "subnet_id" {
  description = "Subnet ID"
  value       = aws_subnet.Day2_public_subnet.id
}

