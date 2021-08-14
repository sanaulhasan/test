

output "config_map_aws_auth" {
  value = local.config_map_aws_auth
}

output "kubeconfig" {
  value = local.kubeconfig
}


output "aws_vpc_id" {
  value = aws_vpc.app.id
}

output "aws_subnets" {
  value = aws_subnet.app.id
}

