resource "aws_efs_file_system" "file_system" {
  creation_token = var.name
  tags = {
    Name = var.name
  }
}

resource "aws_iam_policy" "efs_CSI_driver_policy" {
  name   = "${var.name}-efs-CSI-driver-policy"
  path   = "/"
  policy = file("${path.module}/policy.json")
}

resource "aws_iam_role" "efs_sa_role" {
  assume_role_policy = data.aws_iam_policy_document.oidc.json
  name               = "${var.name}-efs-sa-role"
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  role       = aws_iam_role.efs_sa_role.name
  policy_arn = aws_iam_policy.efs_CSI_driver_policy.arn
}


resource "aws_security_group" "efs" {
  name        = "${var.name}-efs-sg"
  description = "Allow NFS traffic."
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  ingress {
    from_port   = "2049"
    to_port     = "2049"
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.this.cidr_block]
  }
}

resource "aws_efs_mount_target" "efs_mount_target" {
  count           = length(var.subnet_ids)
  file_system_id  = aws_efs_file_system.file_system.id
  subnet_id       = var.subnet_ids[count.index]
  security_groups = [aws_security_group.efs.id]
}