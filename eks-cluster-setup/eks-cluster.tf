# -----------------  CLUSTER PROVISIONING   ---------------

resource "aws_eks_cluster" "myeks-cluster" {
  name     = "myeks-cluster"
  role_arn = aws_iam_role.eks-cluster-role.arn


  vpc_config {
	subnet_ids = [
        aws_subnet.private_subnet_1a.id,
        aws_subnet.private_subnet_1b.id,
        aws_subnet.public_subnet_1a.id,
        aws_subnet.public_subnet_1b.id
    ]
   }

  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKSServicePolicy
  ]
}


resource "aws_eks_node_group" "myeks-node-group" {
  cluster_name    = aws_eks_cluster.myeks-cluster.name
  node_group_name = "myeks-node-group"
  node_role_arn   = aws_iam_role.eks-node-group-role.arn
  subnet_ids      = [
    aws_subnet.private_subnet_1a.id,
    aws_subnet.private_subnet_1b.id
   ]
  
  scaling_config {
    desired_size = 4
    max_size     = 7
    min_size     = 1
  }
  instance_types = ["t3.medium"]

  lifecycle {
    prevent_destroy = false
  
    }
  
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly
  ]
}
