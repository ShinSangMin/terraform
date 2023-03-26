data "aws_iam_role" "eks-addon-ebs-csi-driver-role" {
  name = "${var.eks_cluster_name}-ebs-csi-driver-role"
}

resource "aws_eks_addon" "ebs-csi-driver" {
  cluster_name = "${var.eks_cluster_name}"
  addon_name   = "aws-ebs-csi-driver"
  addon_version = "${var.eks_addon_version_aws_ebs_csi_driver}"
  service_account_role_arn = data.aws_iam_role.eks-addon-ebs-csi-driver-role.arn
  resolve_conflicts = "OVERWRITE"

#  depends_on = [ "${var.eks_cluster_name}" ]
}