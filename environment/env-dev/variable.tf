variable "aws_region" {
    type = string
    default = "us-east-1"
}

//////VPC/////
variable "project_name" {
    type = string
    default = "demo"
}
variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "public_subnet_az1_cidr" {
    type = string
    default = "10.0.1.0/24"
}

variable "public_subnet_az2_cidr" {
    type = string
    default = "10.0.2.0/24"
}

variable "private_subnet_az1_cidr" {
    type = string
    default = "10.0.3.0/24"
}

variable "private_subnet_az2_cidr" {
    type = string
    default = "10.0.4.0/24"
}

variable "desired_size" {
    type = string
    default = "1"
}
variable "max_size" {
    type = string
    default = "2"
}
variable "min_size" {
    type = string
    default = "1"
}
variable "instance_types" {
    type = list(string)
    default = ["t3.medium"]
}








