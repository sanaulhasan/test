

module "eks-cluster-m" {
  source = "../eks-cluster"
}
module "eks-vpc-m" {
  source = "../eks-vpc"
}

resource "aws_iam_role" "app-node" {
  name = "terraform-eks-app-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "app-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.app-node.name
}

resource "aws_iam_role_policy_attachment" "app-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.app-node.name
}

resource "aws_iam_role_policy_attachment" "app-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.app-node.name
}

resource "aws_eks_node_group" "app" {
  cluster_name    = module.eks-cluster-m.aws_eks_cluster_name.name
  node_group_name = var.eks_node_group_name
  node_role_arn   = aws_iam_role.app-node.arn
  subnet_ids      = module.eks-vpc-m.aws_subnets.app[*].id
  instace_type    = var.eks_node_group_instace_type
  ami_type        = var.eks_node_group_ami_type
  disk_size       = var.eks_node_group_disk_size

  scaling_config {
    desired_size = var.eks_node_group_scaling_desired_size
    max_size     = var.eks_node_group_scaling_max_size
    min_size     = var.eks_node_group_scaling_min_size
  }

  depends_on = [
    aws_iam_role_policy_attachment.app-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.app-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.app-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}



