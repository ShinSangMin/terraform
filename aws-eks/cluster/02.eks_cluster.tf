resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.eks_cluster_name}"
  role_arn = aws_iam_role.eks-cluster-role.arn
  version  = "${var.eks_cluster_version}"

  vpc_config {
    security_group_ids = "${var.eks_security_groups}"
    subnet_ids = "${var.eks_subnet_ids}"
    endpoint_private_access = true
    endpoint_public_access = true
    #endpoint_public_access = false
    public_access_cidrs = "${var.eks_public_access_cidrs}"
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks-cluster-role-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-cluster-role-AmazonEKSVPCResourceController,
  ]

  kubernetes_network_config {
    service_ipv4_cidr = "${var.eks_network_ipv4_cidr}"
    ip_family = "${var.eks_network_ip_family}"
  }

  tags = {
    "Name" = "${var.eks_cluster_name}"
    "default-info" = "${var.default-info}"
    "wavve-map" = "${var.wavve-map}"
    "wavve-cost" = "${var.wavve-cost}"
  }
}


resource "aws_eks_addon" "kube-proxy" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "kube-proxy"
  addon_version = "${var.eks_addon_version_kube_proxy}"
  resolve_conflicts = "OVERWRITE"
  
  depends_on = [ aws_eks_cluster.eks_cluster ]
}

#resource "aws_eks_addon" "core_dns" {
#  cluster_name = aws_eks_cluster.eks_cluster.name
#  addon_name   = "coredns"
#  addon_version = "${var.eks_addon_version_core_dns}"
#  resolve_conflicts = "OVERWRITE"

#  depends_on = [ aws_eks_cluster.eks_cluster ]
#}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "vpc-cni"
  addon_version = "${var.eks_addon_version_vpc_cni}"
  resolve_conflicts = "OVERWRITE"

  depends_on = [ aws_eks_cluster.eks_cluster ]
}

output "endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}
