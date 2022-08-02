
locals {
  eks_managed_node_groups = { for k, v in var.node_groups : k => {
    ami_type         = v.ami_type
    desired_capacity = v.desired_capacity
    instance_types   = v.instance_types
    labels           = v.k8s_labels
    block_device_mappings = {
      xvda = {
        device_name = "/dev/xvda"
        ebs = {
          volume_size = v.disk_size
          volume_type = "gp3"
        }
      }
    }
    }
  }
  security_group_rules = { for k, v in var.node_sg_rules : k => {
    description = "${v.type} security group rules for port ${v.port}"
    type        = v.type
    from_port   = v.port
    to_port     = v.port
    protocol    = v.protocol
  } }
}


resource "aws_security_group" "node_groups_sg" {
  name = "${var.cluster_name}-nodegroups-security"
}

resource "aws_security_group_rule" "node_groups_sg_rules" {
  for_each  = local.security_group_rules
  type      = each.value.type
  from_port = each.value.from_port
  to_port   = each.value.to_port
  protocol  = each.value.protocol

  cidr_blocks = [data.aws_vpc.this.cidr_block]

  security_group_id = aws_security_group.node_groups_sg.id
}



module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "18.26.0"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = concat(var.private_subnet_ids, var.public_subnet_ids)

  cluster_security_group_id = aws_security_group.node_groups_sg.id

  manage_aws_auth_configmap = true

  aws_auth_users = var.map_users

  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  eks_managed_node_group_defaults = {
    instance_types = var.instance_types
    subnet_ids     = concat(var.private_subnet_ids, var.public_subnet_ids)
  }

  eks_managed_node_groups = local.eks_managed_node_groups
}

resource "aws_iam_role" "sa_role" {
  assume_role_policy = data.aws_iam_policy_document.oidc.json
  name               = "${var.cluster_name}-sa-role"
}

resource "aws_iam_policy" "sa_policy" {
  name   = "${var.cluster_name}-sa-policy"
  path   = "/"
  policy = file("${path.module}/policy.json")
}

resource "aws_iam_role_policy_attachment" "ddb" {
  role       = aws_iam_role.sa_role.name
  policy_arn = aws_iam_policy.sa_policy.arn
}