# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc-full-cidr
  enable_dns_hostnames = true
  tags = {
    Name = "VPC ${var.project_name}"
  }
}

locals {
  # vpc-net-cidr
  # Return the first 2 octets in a 'Class-A/16' network. eg. 10.20.0.0/16 = 10.20
  vpc-net-cidr = join(".", slice(split(".", var.vpc-full-cidr), 0, 2))
}

# Public Subnets
# Deploy multiple /24 subnets using the 3rd octet starting at 101
# eg. 10.x.101.0/24, 10.x.102.0/24, 10.x.103.0/24
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.vpc.id
  count             = var.num_subnets
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = "${local.vpc-net-cidr}.${101 + count.index}.0/24"
  tags = {
    Name = "${var.project_name}-public-${1 + count.index}"
    tier = "public"
  }
}
# Data to select public subnets
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.vpc.id]
  }

  tags = {
    tier = "public"
  }
}

# Private Subnets
# Deploy multiple /24 subnets using the 3rd octet starting at 1
# eg. 10.x.1.0/24, 10.x.2.0/24, 10.x.3.0/24
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.vpc.id
  count             = var.num_subnets
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = "${local.vpc-net-cidr}.${1 + count.index}.0/24"
  tags = {
    Name = "${var.project_name}-private-${1 + count.index}"
    tier = "private"
  }
}
# Data to select private subnets
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.vpc.id]
  }

  tags = {
    tier = "private"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "igw-${var.project_name}"
  }
}

# Route Table
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    # Route to IGW
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "rt-${var.project_name}"
  }
}

# Route Table Associations
resource "aws_route_table_association" "public" {
  count          = var.num_subnets
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.rt.id
}
resource "aws_route_table_association" "private" {
  count          = var.num_subnets
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.rt.id
}
