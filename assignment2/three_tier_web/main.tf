provider "aws" {
  region = var.region
}
resource "aws_vpc" "reflek_vpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    tags = {
      Name = "reflek_vpc"
    }
}
resource "aws_internet_gateway" "reflek_IG" {
  vpc_id = aws_vpc.reflek_vpc.id
  tags = {
    Name = "reflek_IG"
  }
}
resource "aws_subnet" "reflek_pub_subnet" {
  count = length(var.reflek_public_subnets)
  vpc_id = aws_vpc.reflek_vpc.id
  map_public_ip_on_launch = "true"
  availability_zone = var.availability_zones[count.index]
  cidr_block = var.reflek_public_subnets[count.index]
  tags = {
     Name = "reflek_pub_subnet_${count.index}"
  }
}
resource "aws_route_table" "reflek_pub_route_table" {
  vpc_id = aws_vpc.reflek_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.reflek_IG.id
  }
  tags = {
    Name = "reflek_pub_route_table"
  }
}
resource "aws_route_table_association" "reflek_pub_route_associate" {
  count = length(var.reflek_public_subnets)

  subnet_id = element(aws_subnet.reflek_pub_subnet.*.id, count.index)
  route_table_id = aws_route_table.reflek_pub_route_table.id

}
resource "aws_subnet" "reflek_pri_subnet" {
  count = length(var.reflek_private_subnets)
  vpc_id = aws_vpc.reflek_vpc.id
  availability_zone = var.availability_zones[count.index]
  cidr_block = var.reflek_private_subnets[count.index]
  tags = {
     Name = "reflek_pri_subnet_${count.index}"
  }
}
resource "aws_eip" "reflek_eip_nat" {
  vpc = true
}
resource "aws_nat_gateway" "reflek_nat_gw" {
  allocation_id = aws_eip.reflek_eip_nat.id
  subnet_id =  aws_subnet.reflek_pub_subnet.1.id
}
resource "aws_route_table" "reflek_pri_route_table" {
  vpc_id = aws_vpc.reflek_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.reflek_nat_gw.id
  }
  tags = {
    Name = "reflek_pri_route_table"
  }
}
resource "aws_route_table_association" "reflek_pri_route_associate" {
  count = length(var.reflek_private_subnets)
  subnet_id = element(aws_subnet.reflek_pri_subnet.*.id, count.index)
  route_table_id = aws_route_table.reflek_pri_route_table.id

}
