resource "aws_eks_addon" "core_dns" {
  cluster_name = "${var.eks_cluster_name}"
  addon_name   = "coredns"
  addon_version = "${var.eks_addon_version_core_dns}"
  resolve_conflicts = "OVERWRITE"

#  depends_on = [ "${var.eks_cluster_name}" ]
}