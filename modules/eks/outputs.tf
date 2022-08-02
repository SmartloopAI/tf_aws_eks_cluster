output "cluster_id" {
  description = "Cluster id"
  value       = module.eks.cluster_id
}

output "cluster_security_group_id" {
  description = "Cluster Secruity group id"
  value       = module.eks.cluster_security_group_id
}

output "oidc_provider_arn" {
  description = "oidc provider arn"
  value       = module.eks.oidc_provider_arn
}

output "oidc_issue_url" {
  description = "OIDC issue url"
  value       = module.eks.cluster_oidc_issuer_url
}
