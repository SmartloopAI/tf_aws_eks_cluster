variable "vpc_id" {
  type        = string
  description = "vpc id"
}

variable "cluster_name" {
  type        = string
  description = "Cluster name"
}

variable "cluster_version" {
  type        = string
  description = "EKS cluster version"
  default     = "1.22"
}

variable "disk_size" {
  type        = string
  description = "Disk size"
}

variable "instance_types" {
  type        = list(string)
  description = "nodegroup instance type"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Cluster private subnets"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Cluster public subnets"
}

variable "map_users" {
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  description = "Kubernetes roles"
}

variable "node_groups" {
  type = map(object({
    ami_type         = string
    desired_capacity = string
    disk_size        = string
    instance_types   = list(string)
    k8s_labels       = map(string)

  }))
  description = "nodegroup definition"
}

variable "node_sg_rules" {
  type = map(object({
    type     = string
    port     = string
    protocol = string
    self     = bool
  }))
}

variable "tags" {
  type        = map(string)
  description = "Tags"
  default = {
    Owner = "smartloop"
  }
}
