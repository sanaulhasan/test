

output "config_map_aws_auth" {
  value = local.config_map_aws_auth
}

output "kubeconfig" {
  value = local.kubeconfig
}


output "aws_eks_cluster_name" {
  value = aws_eks_cluster.app.name
}




