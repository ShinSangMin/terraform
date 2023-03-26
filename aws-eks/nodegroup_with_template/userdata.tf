data "aws_eks_cluster" "cluster" {
  name = "${var.eks_cluster_name}"
}

data "template_file" "cloud_init" {
  template = file("${path.module}/cloud-init.sh")
  vars = {
    ClusterCA       = "${data.aws_eks_cluster.cluster.certificate_authority[0].data}"
    APIServerURL    = "${data.aws_eks_cluster.cluster.endpoint}"
    ClusterDNS      = "${var.eks_cluster_dns}"
    ClusterName     = "${var.eks_cluster_name}"
    CustomAMI       = "${var.image_id}"
    NodeGroup       = "${var.eks_nodegroup_name}"
  }
}