provider "aws" {
    region = "us-east-1"
}

resource "aws_eks_cluster" "eks_cluster" {
    name     = "my-eks-cluster"
    role_arn = aws_iam_role.eks_cluster_role.arn

    vpc_config {
        subnet_ids = aws_subnet.eks_subnet[*].id
    }
}

resource "aws_eks_node_group" "eks_node_group" {
    cluster_name    = aws_eks_cluster.eks_cluster.name
    node_group_name = "my-eks-node-group"
    node_role_arn   = aws_iam_role.eks_node_role.arn
    subnet_ids      = aws_subnet.eks_subnet[*].id

    scaling_config {
        desired_size = 1
        max_size     = 1
        min_size     = 1
    }
}