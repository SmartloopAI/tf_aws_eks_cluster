variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-west-2"
}

variable "cluster_name" {
  type        = string
  description = "Cluster name"
}

variable "instance_types" {
  type        = list(string)
  description = "nodegroup instance type"
  default     = ["t3.small"]
}

variable "disk_size" {
  type        = string
  description = "Disk size"
  default     = "40"
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
    min_size = string
  }))
  description = "nodegroup definition"

  default = {
    "node" = {
      ami_type         = "AL2_x86_64"
      desired_capacity = "1"
      min_size = "1"
      disk_size        = "20"
      instance_types   = ["m5.xlarge"]
      k8s_labels = {
        "workload" = "core"
      }
    }
  }
}

variable "node_sg_rules" {
  type = map(object({
    type     = string
    port     = string
    protocol = string
  }))
  default = {
    "argo_cd" = {
      port     = "8080"
      protocol = "tcp"
      type     = "ingress"
    },
  }
}
