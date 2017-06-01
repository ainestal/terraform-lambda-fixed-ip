provider "aws" {
    region = "eu-west-1"
}


//// VPC
resource "aws_vpc" "lambdas" {
    cidr_block = "10.0.0.0/16"
    tags {
        Name = "lambdas-vpc"
    }
}


//// Networks
resource "aws_subnet" "lambdas-private" {
    cidr_block = "10.0.0.0/24"
    vpc_id = "${aws_vpc.lambdas.id}"
    tags {
        Name = "lambdas-private"
    }
}

resource "aws_subnet" "lambdas-public" {
    cidr_block = "10.0.1.0/24"
    vpc_id = "${aws_vpc.lambdas.id}"
    tags {
        Name = "lambdas-public"
    }
}


//// Gateways
resource "aws_internet_gateway" "lambdas" {
    vpc_id = "${aws_vpc.lambdas.id}"
}

resource "aws_nat_gateway" "lambdas" {
    allocation_id = "${aws_eip.lambdas.id}"
    subnet_id     = "${aws_subnet.lambdas-public.id}"
}


//// Route tables Private
resource "aws_route_table" "lambdas-private" {
    vpc_id = "${aws_vpc.lambdas.id}"

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.lambdas.id}"
    }
}

resource "aws_route_table_association" "lambdas-private" {
    route_table_id = "${aws_route_table.lambdas-private.id}"
    subnet_id = "${aws_subnet.lambdas-private.id}"
}


//// Route tables Public
resource "aws_route_table" "lambdas-public" {
    vpc_id = "${aws_vpc.lambdas.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.lambdas.id}"
    }
}

resource "aws_route_table_association" "lambdas-public" {
    route_table_id = "${aws_route_table.lambdas-public.id}"
    subnet_id = "${aws_subnet.lambdas-public.id}"
}


//// ElasticIp
resource "aws_eip" "lambdas" {
    vpc      = true
}
