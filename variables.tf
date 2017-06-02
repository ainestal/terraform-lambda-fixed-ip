variable "region" { default = "eu-west-1" }
variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "vpc_name" { default = "lambdas-vpc" }
variable "private_subnet_cidr" { default = "10.0.0.0/24" }
variable "private_subnet_name" { default = "lambdas-private" }
variable "public_subnet_cidr" { default = "10.0.1.0/24" }
variable "public_subnet_name" { default = "lambdas-public" }
