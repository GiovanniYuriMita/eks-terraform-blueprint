output "cluster_name" {
  description = "The name of the EKS cluster."
  value       = data.aws_eks_cluster.cluster.name
}

output "cluster_endpoint" {
  description = "The endpoint of the EKS cluster."
  value       = data.aws_eks_cluster.cluster.endpoint
}

output "cluster_certificate_authority_data" {
  description = "The certificate authority data for the EKS cluster."
  value       = data.aws_eks_cluster.cluster.certificate_authority[0].data
}

output "cluster_token" {
  description = "The authentication token for the EKS cluster."
  value       = data.aws_eks_cluster_auth.cluster.token
  sensitive = true
}

output "oidc_provider_arn" {
  description = "EKS OIDC provider ARN"
  value       = module.eks.oidc_provider_arn
}

output "worker_role_arn" {
  description = "ARN of default worker node role"
  value       = module.eks.eks_managed_node_groups["${var.node_groups[0].name}"].iam_role_arn
}

output "worker_role_name" {
  description = "Name of default worker node role"
  value       = module.eks.eks_managed_node_groups["${var.node_groups[0].name}"].iam_role_name 
}