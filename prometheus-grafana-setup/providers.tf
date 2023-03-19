provider "aws" {
  region     = "us-east-1"
}


terraform {
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
    }
  }
}


data "aws_eks_cluster" "myeks-cluster" {
  name = "myeks-cluster"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.myeks-cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.myeks-cluster.certificate_authority[0].data)

  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.myeks-cluster.name]
    command     = "aws"
  }
}


provider "kubectl" {
  host                   = data.aws_eks_cluster.myeks-cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.myeks-cluster.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.myeks-cluster.name]
    command     = "aws"
  }
}



data "aws_eks_cluster_auth" "eks-token" {
  name = "myeks-cluster"
}



provider "helm" {
  kubernetes {
  host                   = data.aws_eks_cluster.myeks-cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.myeks-cluster.certificate_authority[0].data)
  token = data.aws_eks_cluster_auth.eks-token.token
  }
}
