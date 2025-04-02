variable "region" { default = "eu-west-2" }
variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "vpc_name" { default = "lambdas-vpc" }
variable "private_subnet_cidr" { default = "10.0.0.0/24" }
variable "private_subnet_name" { default = "lambdas-private" }
variable "public_subnet_cidr" { default = "10.0.1.0/24" }
variable "public_subnet_name" { default = "lambdas-public" }
variable "eip_name" {
    default ="Elastic IP for Lambdas VPC"
}
variable "nat_gateway_name" {
    default = "NAT Gateway for Lambdas VPC"
}
variable "custom_tags" {
  description = "A map of custom tags to apply to resources"
  type        = map(string)
  default     = {}
}