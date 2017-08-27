resource "aws_vpc" "environment" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"

  tags {
    Name = "${var.environment}"
  }
}

resource "aws_internet_gateway" "environment" {
  vpc_id = "${aws_vpc.environment.id}"

  tags {
    Name = "${var.environment}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.environment.id}"

  tags {
    Name = "${var.environment}-public"
  }
}

resource "aws_route_table" "private" {
  count  = "${length(var.private_subnets)}"
  vpc_id = "${aws_vpc.environment.id}"

  tags {
    Name = "${var.environment}-private"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.environment.id}"
}