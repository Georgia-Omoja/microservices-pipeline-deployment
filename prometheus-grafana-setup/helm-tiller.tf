# NAMESPACE
resource "kubernetes_namespace" "tiller" {
  metadata {
    name = "tiller"
  }
}

# SERVICE ACCOUNT
resource "kubernetes_service_account" "tiller" {
  metadata {
    name = "tiller"
    namespace = kubernetes_namespace.tiller.metadata[0].name
  }
}

# CLUSTER ROLE
resource "kubernetes_cluster_role" "helm" {
  metadata {
    name = "helm"
  }
  rule {
    api_groups = ["", "extensions", "apps"]
    resources  = ["nodes", "pods", "services", "endpoints"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["configmaps"]
    verbs      = ["get"]
    resource_names = [      "prometheus-server-conf",      "prometheus-rules",      "prometheus-alerts",      "prometheus-grafana-dashboards",      "prometheus-grafana-datasources",    ]
  }
}


# CLUSTER ROLE BINDING
resource "kubernetes_cluster_role_binding" "tiller" {
  metadata {
    name = "tiller"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = kubernetes_cluster_role.helm.metadata[0].name
  }
  subject {
    kind = "ServiceAccount"
    name = kubernetes_service_account.tiller.metadata[0].name
    namespace = kubernetes_namespace.tiller.metadata[0].name
  }
}


# INITIALIZING HELM
resource "null_resource" "helm_init" {
  provisioner "local-exec" {
    command = "helm init --service-account tiller"
    environment = {
      KUBECONFIG = "~/.kube/config"
    }
  }
  depends_on = [
    kubernetes_service_account.tiller,
    kubernetes_cluster_role_binding.tiller
  ]
}