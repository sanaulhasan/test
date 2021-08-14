

locals {
     env = var.environment
}

module "eks-vpc-m" {
  source = "../eks-vpc"
}

resource "aws_eks_cluster" "app" {
  name     = var.cluster-name
  role_arn = aws_iam_role.app-cluster.arn

  vpc_config {
    security_group_ids = [aws_security_group.app-cluster.id]
    subnet_ids         = module.eks-vpc-m.aws_subnets.app[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.app-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.app-cluster-AmazonEKSServicePolicy,
  ]
}


resource "aws_iam_role" "app-cluster" {
  name = "eks-app-cluster-$(local.env)"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "app-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.app-cluster.name
}

resource "aws_iam_role_policy_attachment" "app-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.app-cluster.name
}


resource "aws_security_group" "app-cluster" {
  name        = "eks-app-cluster-$(local.env)"
  description = "Cluster communication with worker nodes on $(local.env) Environment"
  vpc_id      = module.eks-vpc-m.aws_vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-app-$(local.env)"
  }
}

resource "aws_security_group_rule" "app-cluster-ingress-workstation-https" {
  cidr_blocks       = var.workstation-external-ip
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.app-cluster.id
  to_port           = 443
  type              = "ingress"
}

