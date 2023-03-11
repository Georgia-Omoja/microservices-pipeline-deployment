# -----------------  IAM ROLE PROVISIONING   ---------------

# IAM ROLE FOR EKS CLUSTER
resource "aws_iam_role" "eks-cluster-role" {
  name = "eks-cluster-role"

  assume_role_policy = <<POLICY
    {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "eks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
    }
    POLICY
}

# IAM ROLE POLICY ATTACHMENT FOR EKS CLUSTER
resource "aws_iam_role_policy_attachment" "eks-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster-role.name
}
resource "aws_iam_role_policy_attachment" "eks-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks-cluster-role.name
}

# IAM ROLE FOR EKSNODE-GROUP
resource "aws_iam_role" "eks-node-group-role" {
  name = "eks-node-group-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

# IAM ROLE POLICY ATTACHMENT FOR  EKS NODE-GROUP
resource "aws_iam_role_policy_attachment" "eks-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-node-group-role.name
}
resource "aws_iam_role_policy_attachment" "eks-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-node-group-role.name
}
resource "aws_iam_role_policy_attachment" "mywebapp-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-node-group-role.name
}


# -----------------  CLUSTER PROVISIONING   ---------------

resource "aws_eks_cluster" "mywebapp-cluster" {
  name     = "mywebapp-cluster"
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
    "aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy"
  ]
}


resource "aws_eks_node_group" "mywebapp-node-group" {
  cluster_name    = aws_eks_cluster.mywebapp-cluster.name
  node_group_name = "mywebapp-node-group"
  node_role_arn   = aws_iam_role.eks-node-group-role.arn
  subnet_ids      = [
    aws_subnet.private_subnet_1a.id,
    aws_subnet.private_subnet_1b.id
   ]
  
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
  instance_types = "t2.micro"

  lifecycle {
    prevent_destroy = false
  
    }
  
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_eks_cluster" "socksapp-cluster" {
  name     = "socksapp-cluster"
  role_arn = aws_iam_role.eks-cluster-role.arn


  vpc_config {
	subnet_ids = [
        aws_subnet.private_subnet_1c.id,
        aws_subnet.private_subnet_1d.id,
        aws_subnet.public_subnet_1c.id,
        aws_subnet.public_subnet_1d.id
    ]
   }

  depends_on = [
    "aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy"
  ]
}


resource "aws_eks_node_group" "socksapp-node-group" {
  cluster_name    = aws_eks_cluster.mywebapp-cluster.name
  node_group_name = "socksapp-node-group"
  node_role_arn   = aws_iam_role.eks-node-group-role.arn
  subnet_ids      = [
    aws_subnet.private_subnet_1c.id,
    aws_subnet.private_subnet_1d.id
   ]
  
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
  instance_types = "t2.micro"

  lifecycle {
    prevent_destroy = false
  
    }
  
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
  ]
}