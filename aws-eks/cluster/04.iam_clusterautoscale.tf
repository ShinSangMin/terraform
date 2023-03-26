# Cluster AutoScale
data "aws_iam_policy_document" "eks-cluster-autoscale-role-trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks-cluster-oidc-provider.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:cluster-autoscaler"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks-cluster-oidc-provider.arn]
      type        = "Federated"
    }
  }

  depends_on = [ aws_iam_openid_connect_provider.eks-cluster-oidc-provider ]
}

resource "aws_iam_role" "eks-cluster-autoscale-role" {
  assume_role_policy = data.aws_iam_policy_document.eks-cluster-autoscale-role-trust.json
  name               = "${var.eks_cluster_name}-autoscale"

  depends_on = [ aws_iam_openid_connect_provider.eks-cluster-oidc-provider ]

}

resource "aws_iam_policy" "eks-cluster-autoscale-policy" {
  name = "${var.eks_cluster_name}-nodepool-autoscale-policy"
  path = "/"
  description = "Created by Terraform"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeTags",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup",
                "ec2:DescribeLaunchTemplateVersions"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
  EOF
}

resource "aws_iam_role_policy_attachment" "eks-cluster-autoscale-policy-attachment" {
  role       = aws_iam_role.eks-cluster-autoscale-role.name
  policy_arn = aws_iam_policy.eks-cluster-autoscale-policy.arn

  depends_on = [ aws_iam_role.eks-cluster-autoscale-role ]
}
