#Create VPC resource
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# create internet gateway resource and attach it to vpc
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.project_name}-igw"
  }
}

# use data source to get avalablility zones in the region
data "aws_availability_zones" "availability_zones" {}

# create two public subnets in different AZ
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                    = aws_vpc.vpc.id
  cidr_block                = var.public_subnet_az1_cidr
  map_public_ip_on_launch   = true
  availability_zone         = data.aws_availability_zones.availability_zones.names[0]

  tags = {
    "Name"                                      = "${var.project_name}-public_subnet_az1"
    "kubernetes.io/cluster/${var.project_name}" = "shared"
    "kubernetes.io/role/elb"                    = 1
  }
}

resource "aws_subnet" "public_subnet_az2" {
  vpc_id                    = aws_vpc.vpc.id
  cidr_block                = var.public_subnet_az2_cidr
  map_public_ip_on_launch   = true
  availability_zone         = data.aws_availability_zones.availability_zones.names[1]
  tags = {
    "Name"                                      = "${var.project_name}-public_subnet_az2"
    "kubernetes.io/cluster/${var.project_name}" = "shared"
    "kubernetes.io/role/elb"                    = 1
  }
}

# create public route table

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    "Name" = "${var.project_name}-public_rt"
  }
}

# associate public subnet public-subnet_az1 to "public route table"

resource "aws_route_table_association" "public_rt_association_az1" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_rt.id
}

# associate public subnet pub-sub2 to "public route table"

resource "aws_route_table_association" "public_rt_association_az2" {
  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public_rt.id
}

# create two private subnets in different az

resource "aws_subnet" "private_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.availability_zones.names[0]
  map_public_ip_on_launch = false
  
  tags = {
    "Name"                                      = "${var.project_name}-private_subnet_az1"
    "kubernetes.io/cluster/${var.project_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = 1
  }
}

resource "aws_subnet" "private_subnet_az2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.availability_zones.names[1]
  map_public_ip_on_launch = false

  tags = {
    "Name"                                      = "${var.project_name}-private_subnet_az2"
    "kubernetes.io/cluster/${var.project_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = 1
  }
}

#create two private route table, one for each private subnet
resource "aws_route_table" "private_rt_az1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block    = "0.0.0.0/0"
    gateway_id    = aws_nat_gateway.nat_gw_az1.id
  }

  tags = {
    "Name" = "${var.project_name}-private_rt_az1"
  }
}

resource "aws_route_table" "private_rt_az2" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_az2.id
  }

  tags = {
    Name = "${var.project_name}-private_rt_az2"
  }
}

# associate private_subnet_az1 with private_rt_az1
resource "aws_route_table_association" "pri_sub_association_az1" {
  subnet_id      = aws_subnet.private_subnet_az1.id
  route_table_id = aws_route_table.private_rt_az1.id
}

# associate private subnet pri-sub4 with private route pri-rt-b
resource "aws_route_table_association" "pri-sub4-with-pri-rt-b" {
  subnet_id      = aws_subnet.private_subnet_az2.id
  route_table_id = aws_route_table.private_rt_az2.id
}