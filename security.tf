#--Provision VPC Security Groups
resource "aws_security_group" "nick_bastion" {
    vpc_id      = aws_vpc.nick_vpc.id
    name        = "BastionSecurityGroup-${local.environment}"
    description = "SSH and Egress to Bastion host"
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [var.wan_edge_ip]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name        = "BastionSecurityGroup-${local.environment}"
        Environment = "${local.environment}"
    }
}

resource "aws_security_group" "nick_private" {
    vpc_id      = aws_vpc.nick_vpc.id
    name        = "PrivateSecurityGroup-${local.environment}"
    description = "SSH and Egress for Private Subnet"
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [var.bastion_cidr]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name        = "PrivateSecurityGroup-${local.environment}"
        Environment = "${local.environment}"
    }
}

#--Provision NACLs
resource "aws_network_acl" "nick_bastion" {
    vpc_id = aws_vpc.nick_vpc.id
    subnet_ids  = [aws_subnet.nick_bastion.id]
    ingress {
        protocol   = "tcp"
        rule_no    = 100
        action     = "allow"
        cidr_block = var.wan_edge_ip
        from_port  = 22
        to_port    = 22
    }
    ingress {
        protocol   = "-1"
        rule_no    = 199
        action     = "allow"
        cidr_block = var.private_cidr
        from_port  = 0
        to_port    = 0
    }
    egress {
        protocol   = -1 #--All
        rule_no    = 1000
        action     = "allow"
        cidr_block = "0.0.0.0/0"
        from_port  = 0
        to_port    = 0
    }   
    tags = {
        Name        = "BastionNACL-${local.environment}"
        Environment = "${local.environment}"
    }
}

resource "aws_security_group" "sgwebservers" {
  name              = "sgwebservers-${local.environment}"
  description       = "Enable Web Servers-${local.environment}"

  ingress {
    description     = "TLS from VPC"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description     = "SSH from VPC"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}
