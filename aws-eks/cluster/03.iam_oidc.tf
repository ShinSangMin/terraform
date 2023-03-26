# EKS OIDC URL read
data "tls_certificate" "eks-cluster-oidc" {
  url = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer

  depends_on = [ aws_eks_cluster.eks_cluster ]
}

# IAM OIDC Provider registry
resource "aws_iam_openid_connect_provider" "eks-cluster-oidc-provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks-cluster-oidc.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer

  depends_on = [ aws_eks_cluster.eks_cluster ]
}
