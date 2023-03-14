variable "region" {
    description = "my aws VPC region"
}

variable "vpc_cidr_block" {
    description = "CIDR for the VPC"
}

variable "private_subnet_1A_cidr_block" {
    description = "CIDR for the private subnet 1A"
}

variable "public_subnet_1A_cidr_block" {
    description = "CIDR for the public subnet 1A"
}

variable "private_subnet_1B_cidr_block" {
    description = "CIDR for the private subnet 1B"
}

variable "public_subnet_1B_cidr_block" {
    description = "CIDR for the public subnet 1B"
}
