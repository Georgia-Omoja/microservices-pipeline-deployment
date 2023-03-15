output "endpoint" {
  value = aws_eks_cluster.myeks-cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.myeks-cluster.certificate_authority[0].data
}