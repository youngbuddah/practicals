output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public-main.id
}

output "private_subnet_id" {
  value = aws_subnet.private-main.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gw.id
}
