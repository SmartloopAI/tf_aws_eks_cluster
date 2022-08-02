
module "eks" {
  source             = "./modules/eks"
  cluster_name       = var.cluster_name
  vpc_id             = data.aws_vpc.this.id
  private_subnet_ids = data.aws_subnets.private.ids
  public_subnet_ids  = data.aws_subnets.public.ids
  map_users          = var.map_users
  instance_types     = var.instance_types
  disk_size          = var.disk_size
  node_groups        = var.node_groups
  node_sg_rules      = var.node_sg_rules
}

module "efs" {
  source            = "./modules/efs"
  vpc_id            = data.aws_vpc.this.id
  subnet_ids        = data.aws_subnets.private.ids
  name              = var.cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_issue_url    = module.eks.oidc_issue_url

  depends_on = [
    module.eks
  ]
}