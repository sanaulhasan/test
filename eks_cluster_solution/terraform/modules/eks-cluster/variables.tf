
variable "cluster-name" {
  default = "terraform-eks-demo"
  type    = string
}

variable "environment" {
  type    = string
}

variable "workstation-external-ip" {
  type    = string
}