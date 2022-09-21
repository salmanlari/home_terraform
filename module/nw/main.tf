provider "aws" {
    region = "ap-south-1"
    
}  

data "aws_availability_zones" "available" {
  state = "available"
}

# AWS_VPC

resource "aws_vpc" "vpc_id" {
  cidr_block        = var.vpc_cidr
  instance_tenancy  = "default"

  tags = {
    Name = "${terraform.workspace}_vpc"
  }
}

#SUBNET

resource "aws_subnet" "vpc_pub_snet" {
  for_each          = var.pub_snet
  vpc_id            = aws_vpc.vpc_id.id
  cidr_block        = each.value ["cidr"]
  availability_zone = each.value["az"]

  tags = {
    Name = "${terraform.workspace}_pub_snet"
  }
}
resource "aws_subnet" "vpc_pvt_snet" {
  for_each          = var.pvt_snet
  vpc_id            = aws_vpc.vpc_id.id
  cidr_block        = each.value ["cidr"]
  availability_zone = each.value ["az"]

  tags = {
    Name = "${terraform.workspace}_pvt_snet"
  }
}

#VPC_IGW

resource "aws_internet_gateway" "vpc_igw" {
  vpc_id     = aws_vpc.vpc_id.id

  tags = {
     Name = "${terraform.workspace}_igw"
   }
}

#ROUTE TABLES
resource "aws_route_table" "vpc_rt" {
  vpc_id           = aws_vpc.vpc_id.id

  route {
    cidr_block     = var.rt_cidr
    gateway_id     = aws_internet_gateway.vpc_igw.id
  }

  tags = {
    Name = "${terraform.workspace}_vpc_rt"
  }
}

# ROUTE TABLE ASSOCIATION

resource "aws_route_table_association" "vpc_rta" {
  for_each           = aws_subnet.vpc_pub_snet
  subnet_id          = each.value.id
  route_table_id     = aws_route_table.vpc_rt.id
}

#  #ELASTIC IP

#  resource "aws_eip" "vpc_ng_eip" {
# }

# # #NAT GATEWAY

# resource "aws_nat_gateway" "vpc_ng" {
#    count            = var.is_nat_required ? 1 : 0
#    allocation_id    = aws_eip.vpc_ng_eip.id
#    subnet_id        = lookup(aws_subnet.vpc_pub_snet,var.ng_pub_snet_id,null).id

#    tags = {
#      Name = "${terraform.workspace}_nat-gateway"
#    }
#  }