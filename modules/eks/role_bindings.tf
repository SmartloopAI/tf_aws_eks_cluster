resource "kubernetes_cluster_role_binding" "binding" {
  metadata {
    name = "admin-privilege"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  dynamic "subject" {
    for_each = var.map_users

    content {
      kind      = "User"
      name      = subject.value["username"]
      api_group = "rbac.authorization.k8s.io"
    }
  }
}