resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr

  tags = {
    Name = var.subnet_name
  }
}
# Terraform Implicit Dependency
# If one resource uses an attribute of another resource, Terraform creates a dependency between them automatically.
# Terraform automatically understands the order of resource creation based on references between resources without you explicitly telling it.