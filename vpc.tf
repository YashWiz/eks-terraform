resource "aws_vpc" "eks_vpc" {
    cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "eks_igw" {
    vpc_id = aws_vpc.eks_vpc.id
}

resource "aws_route_table" "eks_public_rt" {
    vpc_id = aws_vpc.eks_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.eks_igw.id
    }
}

resource "aws_subnet" "eks_subnet" {
    count = 2
    vpc_id     = aws_vpc.eks_vpc.id
    cidr_block = cidrsubnet(aws_vpc.eks_vpc.cidr_block, 8, count.index)
    availability_zone = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = true
}

resource "aws_route_table_association" "eks_public_rt_assoc" {
    count          = 2
    subnet_id      = aws_subnet.eks_subnet[count.index].id
    route_table_id = aws_route_table.eks_public_rt.id
}

data "aws_availability_zones" "available" {}