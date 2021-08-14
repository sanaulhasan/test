
variable "eks_node_group_name" {  type = string  }

variable "eks_node_group_instace_type" {  type = string  }

variable "eks_node_group_ami_type" {
         type = string  
         default = AL2_x86_64
     }

variable "eks_node_group_disk_size" {  
         type = number  
         default = 20
     }

variable "eks_node_group_scaling_desired_size" {
         type = number  
         default = 2
     }

variable "eks_node_group_scaling_max_size" {
         type = number  
         default = 6
     }

variable "eks_node_group_scaling_min_size" {
        type = number  
         default = 2
     }


