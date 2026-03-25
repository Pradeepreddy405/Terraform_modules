output "ec2_public_ip" {
  description = "Public IP of EC2"
  value       = aws_instance.day3_ec2.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS of EC2"
  value       = aws_instance.day3_ec2.public_dns
}

output "vpc_id" {
  value = aws_vpc.day3_vpc.id
}

output "subnet_id" {
  value = aws_subnet.day3_public_subnet.id
}