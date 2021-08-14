
terraform {
	backend "S3" {
      bucket = "$(var.env)-state"
      key    = "$(var.env)-terraform.tfstate"
      regios = var.aws_region
	}
}

provider "aws" {
  version = "~> 3.0"
  region  = var.aws_region
}


data "http" "workstation-external-ip" {
  url = "http://ipv4.icanhazip.com"
}

locals {
  workstation-external-cidr = "${chomp(data.http.workstation-external-ip.body)}/32"
}



module "my_eks_cluster" {
	source = "../../module/eks-cluster"
	# vars

	environment = var.env
    workstation-external-cidr = "${chomp(data.http.workstation-external-ip.body)}/32"
    cluster-name = "My_$(var.env)_eks_cluster"


}

module "my_eks_worker" {
	source = "../../module/eks-worker"
	# vars

	eks_node_group_name                 = "My_$(var.env)_eks_node_group"
	eks_node_group_instace_type         = "t2.medium"
	eks_node_group_disk_size            = 15
	eks_node_group_scaling_desired_size = 2
	eks_node_group_scaling_max_size     = 4
	eks_node_group_scaling_min_size     = 2
}

module "my_eks_vpc" {
	source = "../../module/eks-vpc"
	# vars

    vpc_cidr_block  = "10.0.0.0/16" 
    vpc_name = "terraform-eks-app-$(var.env)" 
}


