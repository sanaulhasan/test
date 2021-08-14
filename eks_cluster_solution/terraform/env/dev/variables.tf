

variable "env" {
        type = string
     }

variable "aws_region" {
        type = string
        default = "us-west-1"
     }     

variable "cluster-name" {
  default = "terraform-eks-demo"
  type    = string
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16" 
  type    = string
}

variable "eks_node_group_name" {  
        type = string  }

variable "eks_node_group_instace_type" {  
      type = string  }


variable "eks_node_group_scaling_desired_size" {
         type = number  
         default = 2
     }

variable "eks_node_group_scaling_max_size" {
         type = number  
         default = 6
     }
