output "vpc_id" {
  value = aws_vpc.lambdas.id
}

output "private_subnet_id" {
  value = aws_subnet.lambdas-private.id
}

output "eip_id" {
  value = aws_eip.lambdas.id
}

output "aws_security_group" {
  value = aws_security_group.allow_tls
}
