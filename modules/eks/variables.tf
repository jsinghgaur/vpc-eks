variable "project_name" {
  type = string
}

variable "desired_size" {
    type = string
}
variable "max_size" {
    type = string
}
variable "min_size" {
    type = string
}
variable "instance_types" {}
variable "public_subnet_az1_id" {}
variable "public_subnet_az2_id" {}
variable "private_subnet_az1_id" {}
variable "private_subnet_az2_id" {}
