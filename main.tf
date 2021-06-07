provider "aws" {
  region = var.region
}


//// VPC
resource "aws_vpc" "lambdas" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}


//// Networks
resource "aws_subnet" "lambdas-private" {
  cidr_block = var.private_subnet_cidr
  vpc_id     = aws_vpc.lambdas.id
  tags = {
    Name = var.private_subnet_name
  }
}

resource "aws_subnet" "lambdas-public" {
  cidr_block = var.public_subnet_cidr
  vpc_id     = aws_vpc.lambdas.id
  tags = {
    Name = var.public_subnet_name
  }
}


//// Gateways
resource "aws_internet_gateway" "lambdas" {
  vpc_id = aws_vpc.lambdas.id
}

resource "aws_nat_gateway" "lambdas" {
  allocation_id = aws_eip.lambdas.id
  subnet_id     = aws_subnet.lambdas-public.id
}


//// Route tables Private
resource "aws_route_table" "lambdas-private" {
  vpc_id = aws_vpc.lambdas.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.lambdas.id
  }
}

resource "aws_route_table_association" "lambdas-private" {
  route_table_id = aws_route_table.lambdas-private.id
  subnet_id      = aws_subnet.lambdas-private.id
}


//// Route tables Public
resource "aws_route_table" "lambdas-public" {
  vpc_id = aws_vpc.lambdas.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lambdas.id
  }
}

resource "aws_route_table_association" "lambdas-public" {
  route_table_id = aws_route_table.lambdas-public.id
  subnet_id      = aws_subnet.lambdas-public.id
}


//// ElasticIp
resource "aws_eip" "lambdas" {
  vpc = true
  tags = {
    Name = var.eip_name
  }
}

resource "aws_security_group" "allow_tls" {
  depends_on = [
    aws_vpc.lambdas
  ]
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.lambdas.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
