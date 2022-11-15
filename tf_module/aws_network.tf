# Create the VPC
resource "aws_vpc" "hyb303_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "hyb303-vpc"
  }
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.hyb303_vpc.id
}

# Create subnets in parent region; coredns runs here
resource "aws_subnet" "region_subnets" {
  for_each = var.availability_zones

  vpc_id = aws_vpc.hyb303_vpc.id

  cidr_block           = each.value.cidr_block
  availability_zone_id = each.value.availability_zone_id

  tags = {
    Name = "hyb303-region-subnet-${each.key}"
  }
}

# Create subnets in each edge zone
resource "aws_subnet" "wavelength_subnets" {
  for_each = var.wavelength_zones

  vpc_id = aws_vpc.hyb303_vpc.id

  cidr_block           = each.value.cidr_block
  availability_zone_id = each.value.availability_zone_id

  tags = {
    Name = "hyb303-wlz-edge-subnet-${each.key}"
  }
}
resource "aws_subnet" "localzones_subnets" {
  for_each = var.local_zones

  vpc_id = aws_vpc.hyb303_vpc.id

  cidr_block           = each.value.cidr_block
  availability_zone_id = each.value.availability_zone_id

  tags = {
    Name = "hyb303-lz-edge-subnet-${each.key}"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "hyb303_internet_gw" {
  vpc_id = aws_vpc.hyb303_vpc.id
  tags = {
    Name = "hyb303-internet-gw"
  }
}

# Create Carrier Gateway
resource "aws_ec2_carrier_gateway" "hyb303_carrier_gateway" {
  vpc_id = aws_vpc.hyb303_vpc.id
  tags = {
    Name = "hyb303-carrier-gw"
  }
}