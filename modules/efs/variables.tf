variable "vpc_id" {
  type        = string
  description = "vpc id"
}

variable "name" {
  type        = string
  description = "Name of the file system"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Cluster subnets ids"
}

variable "oidc_provider_arn" {
  type        = string
  description = "OIDC provider arn"
}

variable "oidc_issue_url" {
  type        = string
  description = "OIDC issue url"
}