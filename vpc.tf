#--Provision VPC
resource "aws_vpc" "nick_vpc" {
    cidr_block = var.vpc_address_space
    tags = {
        Name        = "VPC-${local.environment}"
        Environment = local.environment
    }
}

#--Provision Subnets
resource "aws_subnet" "nick_bastion" {
    vpc_id                  = aws_vpc.nick_vpc.id
    cidr_block              = var.bastion_cidr
    map_public_ip_on_launch = "true"
    tags = {
        Name        = "BastionSubnet-${local.environment}"
        Environment = local.environment
    }
}

resource "aws_subnet" "nick_private" {
    vpc_id                  = aws_vpc.nick_vpc.id
    cidr_block              = var.private_cidr
    map_public_ip_on_launch = "false"
    tags = {
        Name        = "PrivateSubnet-${local.environment}"
        Environment = local.environment
    }
}

#--Provision Gateways
resource "aws_internet_gateway" "nick_igw" {
    vpc_id = aws_vpc.nick_vpc.id
    tags = {
        Name        = "IGW-${local.environment}"
        Environment = local.environment
    }
}

resource "aws_eip" "nick_nat" {
    vpc = true
    tags = {
        Name        = "EIP-NATGW-${local.environment}"
        Environment = local.environment
    }
}

resource "aws_nat_gateway" "nick_ngw" {
    allocation_id = aws_eip.nick_nat.id
    subnet_id     = aws_subnet.nick_bastion.id
    tags = {
        Name        = "NATGW-${local.environment}"
        Environment = local.environment
    }
    depends_on    = [
        aws_internet_gateway.nick_igw
    ]
}

#--Provision Route Tables
resource "aws_route_table" "nick_bastion" {
    vpc_id = aws_vpc.nick_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.nick_igw.id
    }
    tags = {
        Name        = "BastionRouteTable-${local.environment}"
        Environment = local.environment
    }
}

resource "aws_route_table_association" "nick_bastion" {
    subnet_id      = aws_subnet.nick_bastion.id
    route_table_id = aws_route_table.nick_bastion.id
}

resource "aws_route_table" "nick_private" {
    vpc_id = aws_vpc.nick_vpc.id
    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nick_ngw.id
    }
    tags = {
        Name        = "PrivateRouteTable-${local.environment}"
        Environment = local.environment
    }
}

resource "aws_route_table_association" "nick_private" {
    subnet_id      = aws_subnet.nick_private.id
    route_table_id = aws_route_table.nick_private.id
}
