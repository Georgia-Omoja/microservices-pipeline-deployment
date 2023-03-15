# PROMETHEUS NAMESPACE
resource "kubernetes_namespace" "prometheus" {
  metadata {
    name = "prometheus"
  }
}

#PROMETHEUS INSTALLATION AND CONGIGURATION
resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = "14.3.1"
  namespace  = kubernetes_namespace.prometheus.metadata[0].name

 set {
    name  = "server.global.scrape_interval"
    value = "1m"
  }

  set {
    name  = "server.global.scrape_timeout"
    value = "10s"
  }

    set {
        name = "server.global.evaluation_interval"
        value = "1m"
    }

    set {
    name = "server.persistentVolume.storageClass"
    value = "gp2"
    }

    set {
    name = "server.persistentVolume.size"
    value = "8Gi"
    }

    set {
    name = "alertmanager.persistentVolume.storageClass"
    value = "gp2"
    }

    set {
    name = "alertmanager.persistentVolume.size"
    value = "8Gi"
    }


  set {
    name  = "server.service.annotations.prometheus.io/scrape"
    value = "true"
  }

 set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "server.service.port"
    value = "80"
  }

  set {
      name  = "server.service.targetPort"
      value = "9090"
    }

  set {
    name  = "server.service.annotations.service.beta.kubernetes.io/aws-load-balancer-type"
    value = "nlb"
  }

  set {
    name  = "server.service.annotations.service.beta.kubernetes.io/aws-load-balancer-internal"
    value = "false"
  }

  set {
    name  = "alertmanager.enabled"
    value = "true"
  }

  set {
    name  = "kube-state-metrics.enabled"
    value = "true"
  }

  set {
    name  = "node-exporter.enabled"
    value = "true"
  }

 set {
    name  = "prometheusRuleSelector.matchLabels.app"
    value = "webapp"
  }

  set {
      name  = "config.global.smtp_smarthost"
      value = "smtp.gmail.com:587"
    }

  set {
    name  = "config.global.smtp_from"
    value = "my-alerts@gmail.com"
  }

  set {
    name  = "config.receivers[0].name"
    value = "my-email-receiver"
  }

  set {
    name  = "config.receivers[0].email_configs[0].to"
    value = "georgiaomoja@gmail.com"
  }

  set {
    name  = "config.routes.receiver"
    value = "my-email-receiver"
  }

    set {
        name  = "server.additionalScrapeConfigs[0].job_name"
        value = "kubernetes-apiservers"
    }

  set {
    name  = "server.additionalScrapeConfigs[0].scheme"
    value = "https"
  }

  set {
    name  = "server.additionalScrapeConfigs[0].tls_config.ca_file"
    value = "/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
  }

  set {
    name  = "server.additionalScrapeConfigs[0].bearer_token_file"
    value = "/var/run/secrets/kubernetes.io/serviceaccount/token"
  }

  set {
    name  = "server.additionalScrapeConfigs[0].job_name"
    value = "kubernetes-nodes"
  }

  set {
    name  = "server.additionalScrapeConfigs[0].scheme"
    value = "https"
  }

  set {
    name  = "server.additionalScrapeConfigs[0].kubernetes_sd_configs[0].role"
    value = "eks-node-group-role"
  }

  set {
    name  = "server.additionalScrapeConfigs[0].relabel_configs[0].source_labels[0]"
    value = "__meta_kubernetes_node_name"
  }

  set {
    name  = "server.additionalScrapeConfigs[0].relabel_configs[0].action"
    value = "replace"
  }

  set {
    name  = "server.additionalScrapeConfigs[0].relabel_configs[0].target_label"
    value = "node"
  }

  set {
    name  = "server.additionalScrapeConfigs[0].relabel_configs[1].source_labels[0]"
    value = "__meta_kubernetes_namespace"
  }

  set {
    name  = "server.additionalScrapeConfigs[0].relabel_configs[1].action"
    value = "replace"
  }

  set {
    name  = "server.additionalScrapeConfigs[0].relabel_configs[1].target_label"
    value = "namespace"
  }

  set {
    name  = "server.additionalScrapeConfigs[0].relabel_configs[2].source_labels[0]"
    value = "__meta_kubernetes_pod_name"
  }

  set {
    name  = "server.additionalScrapeConfigs[0].relabel_configs[2].action"
    value = "replace"
  }

  set {
    name  = "server.additionalScrapeConfigs[0].relabel_configs[2].target_label"
    value = "pod"
  }

  set {
    name  = "server.additionalScrapeConfigs[0].relabel_configs[3].source_labels[0]"
    value = "__meta_kubernetes_pod_container_name"
  }

  set {
    name  = "server.additionalScrapeConfigs[0].relabel_configs[3].action"
    value = "replace"
  }

  set {
    name  = "server.additionalScrapeConfigs[0].relabel_configs[3].target_label"
    value = "container"
  }
}


  resource "kubernetes_namespace" "grafana" {
  metadata {
    name = "grafana"
  }
}

resource "helm_release" "grafana" {
  name       = "grafana"
  chart      = "grafana/grafana"
  namespace  = kubernetes_namespace.grafana.metadata[0].name
  repository = "https://grafana.github.io/helm-charts"
  values = [
    jsonencode({
      "adminUser"           = "admin"
      "adminPassword"       = "password"
      "ingress.enabled"     = true
      "ingress.annotations.kubernetes.io/ingress.class" = "nginx"
      "ingress.hosts[0].name"     = "grafana.example.com"
      "ingress.hosts[0].paths[0]" = "/"
      "persistence.enabled" = false
      "plugins" = {
        "grafana-kubernetes-app" = {
          "enabled" = true
          "version" = "3.2.1"
        }
      }
      "datasources" = {
        "datasources[0].name"     = "Prometheus"
        "datasources[0].type"     = "prometheus"
        "datasources[0].url"      = "http://prometheus-server.prometheus.svc.cluster.local:9090"
        "datasources[0].access"   = "proxy"
        "datasources[0].basicAuth"= false
        "datasources[0].isDefault"= true
      }
    })
  ]
}

resource "kubernetes_secret" "grafana" {
  metadata {
    name = "grafana"
    namespace = kubernetes_namespace.grafana.metadata[0].name
  }

  data = {
    "GF_SECURITY_ADMIN_PASSWORD" = "password"
  }

  type = "Opaque"
}

resource "kubernetes_service" "grafana" {
  metadata {
    name = "grafana"
    namespace = kubernetes_namespace.grafana.metadata[0].name
  }

  spec {
    selector = {
      app = "grafana"
    }

    port {
      name = "http"
      port = 80
      target_port = 3000
    }

    type = "LoadBalancer"
    load_balancer_source_ranges = ["0.0.0.0/0"]
  }
}



