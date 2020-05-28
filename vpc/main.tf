resource "aws_vpc" "vpc" {
  cidr_block = var.subnet

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = var.tags
}

resource "aws_subnet" "public" {
  count             = length(var.azs) # one per AZ
  vpc_id            = aws_vpc.vpc.id
  availability_zone = element(var.azs, count.index)

  # Assign IPs in the x.xx.y.0 subnet, with x based on the VPC environment and y is based on the number of subnets being created
  cidr_block = cidrsubnet(var.subnet, 8, count.index)

  tags = var.tags
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = var.tags
}

resource "aws_route_table" "table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.gateway.id
  }

  tags = var.tags
}

resource "aws_main_route_table_association" "vpc" {
  vpc_id         = aws_vpc.vpc.id
  route_table_id = aws_route_table.table.id
}

resource "aws_route_table_association" "subnet" {
  count = length(var.azs) # one per AZ

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.table.id
}
