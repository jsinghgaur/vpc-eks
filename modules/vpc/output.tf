output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_az1_id" {
  value = aws_subnet.public_subnet_az1.id
}
output "public_subnet_az2_id" {
  value = aws_subnet.public_subnet_az2.id
}
output "private_subnet_az1_id" {
  value = aws_subnet.private_subnet_az1.id
}

output "private_subnet_az2_id" {
  value = aws_subnet.private_subnet_az2.id
}
output "igw_id" {
    value = aws_internet_gateway.igw.id
}
