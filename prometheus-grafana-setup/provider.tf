provider "kubernetes" {
  config_context_cluster = "myeks-cluster"
}

provider "helm" {
  kubernetes {
    config_context_cluster = "myeks-cluster"
  }
}

