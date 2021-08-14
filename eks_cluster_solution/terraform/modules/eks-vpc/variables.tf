#
# Variables Configuration
#

variable "vpc_cidr_block" {
  default = "10.0.0.0/16" 
  type    = string
}

variable "vpc_name" {
  type    = string
}
