# create EIP for nat-gateway-az1
resource "aws_eip" "eip_1" {
  tags = {
    Name = "EIP1"
  }
}

# create EIP for nat-gateway-az2
resource "aws_eip" "eip_2" {
  tags = {
    Name = "EIP2"
  }
}

#create two nat-gateways, one in each public subnet for high availability
resource "aws_nat_gateway" "nat_gw_az1" {
  allocation_id   = aws_eip.eip_1.id
  subnet_id       = aws_subnet.public_subnet_az1.id

  tags = {
    Name = "nat_gw1"
  }
}

resource "aws_nat_gateway" "nat_gw_az2" {
  allocation_id   = aws_eip.eip_2.id
  subnet_id       = aws_subnet.public_subnet_az2.id

  tags = {
    Name = "nat_gw2"
  }
}

