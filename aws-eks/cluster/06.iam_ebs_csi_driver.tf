# AWS EBS CSI Driver
data "aws_iam_policy_document" "eks-cluster-addon-ebs-csi-driver-policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks-cluster-oidc-provider.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks-cluster-oidc-provider.url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks-cluster-oidc-provider.arn]
      type        = "Federated"
    }
  }

  depends_on = [ aws_iam_openid_connect_provider.eks-cluster-oidc-provider ]
}

resource "aws_iam_role" "eks-cluster-addon-ebs-csi-driver-role" {
  assume_role_policy = data.aws_iam_policy_document.eks-cluster-addon-ebs-csi-driver-policy.json
  name               = "${var.eks_cluster_name}-ebs-csi-driver-role"

}

resource "aws_iam_role_policy_attachment" "eks-cluster-addon-ebs-csi-driver-policy-attachment" {
  role       = aws_iam_role.eks-cluster-addon-ebs-csi-driver-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"

  depends_on = [ aws_iam_role.eks-cluster-addon-ebs-csi-driver-role ]
}