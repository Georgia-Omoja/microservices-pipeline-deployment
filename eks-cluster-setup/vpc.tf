# VPC 
resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr_block
    
    tags = {
        Name = "vpc-001"
        "kubernetes.io/cluster/myeks-cluster" = "shared"
    }
}

# PRIVATE SUBNET 1A
resource "aws_subnet" "private_subnet_1a" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.private_subnet_1A_cidr_block
    availability_zone = us-east-1a

    tags = {
        Name = "PRIVATE SUBNET 1A"
        "kubernetes.io/cluster/myeks-cluster" = "shared"
    }

}

# PUBLIC SUBNET 1A
resource "aws_subnet" "public_subnet_1a" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.public_subnet_1A_cidr_block
    availability_zone = us-east-1a

    tags = {
        Name = "PUBLIC SUBNET 1A"
        "kubernetes.io/cluster/myeks-cluster" = "shared"
    }

}

# PRIVATE SUBNET 1B
resource "aws_subnet" "private_subnet_1b" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.private_subnet_1B_cidr_block
    availability_zone = us-east-1b

    tags = {
        Name = "PRIVATE SUBNET 1A"
        "kubernetes.io/cluster/myeks-cluster" = "shared"

    }

}

# PUBLIC SUBNET 1B
resource "aws_subnet" "public_subnet_1b" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.public_subnet_1B_cidr_block
    availability_zone = us-east-1b

    tags = {
        Name = "PUBLIC SUBNET 1B"
        "kubernetes.io/cluster/myeks-cluster" = "shared"
    }

}

# INTERNET GATEWAY
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name = "igw-001"
    }
}

# ELASTIC IP FOR NAT GATEWAY
resource "aws_eip" "natip01" {
    vpc = true

    tags = {
      "Name" = "natip-01"
    }
  
}

# NAT GATEWAY
resource "aws_nat_gateway" "natgateway01" {
    allocation_id = aws_eip.natip01.id
    subnet_id = aws_subnet.public_subnet_1a.id

    tags = {
      "Name" = "nat-gateway01"
    }

    depends_on = [
      aws_internet_gateway.igw
    ]
}

# ROUTE TABLE FOR PRIVATE SUBNETS
resource "aws_route_table" "private-rtb" {
    vpc_id = aws_vpc.vpc.id

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_nat_gateway.natgateway01.id
    }

    tags = {
        "Name" = "private-rtb"
    }
}

# SUBNET ASSOCIATION OF ROUTE TABLE FOR PRIVATE SUBNETS 
resource "aws_route_table_association" "private-rtb-1a" {
    subnet_id = aws_subnet.private_subnet_1a.id
    route_table_id = aws_route_table.private-rtb.id     
}
resource "aws_route_table_association" "private-rtb-1b" {
    subnet_id = aws_subnet.private_subnet_1b.id
    route_table_id = aws_route_table.private-rtb.id     
}

# ROUTE TABLE FOR PUBLIC SUBNETS
resource "aws_route_table" "public-rtb" {
    vpc_id = aws_vpc.vpc.id

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        "Name" = "public-rtb"
    }
}

# SUBNET ASSOCIATION OF ROUTE TABLE FOR PUBLIC SUBNETS 
resource "aws_route_table_association" "public-rtb-1a" {
    subnet_id = aws_subnet.public_subnet_1a.id
    route_table_id = aws_route_table.public-rtb.id     
}
resource "aws_route_table_association" "public-rtb-1b" {
    subnet_id = aws_subnet.public_subnet_1b.id
    route_table_id = aws_route_table.public-rtb.id     
}

resource "aws_security_group" "eks-security-group" {
  name = "eks-security-group"
  description = "Security group for EKS cluster"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}