data "aws_iam_role" "ng_role" {
  name = "${var.ng_iam_role}"
}

resource "aws_eks_node_group" "eks_nodegroup" {
  cluster_name    = "${var.eks_cluster_name}"
  node_group_name = "${var.eks_nodegroup_name}"
  node_role_arn   = "${data.aws_iam_role.ng_role.arn}"
  subnet_ids      = "${var.eks_subnet_ids}"

  capacity_type = "ON_DEMAND"
  # AL2_x86_64 | AL2_x86_64_GPU | AL2_ARM_64 | CUSTOM | BOTTLEROCKET_ARM_64 | BOTTLEROCKET_x86_64
  # labels = {}

  ami_type = "AL2_x86_64"
  disk_size = "${var.volume_size}"
  instance_types = ["${var.instance_type}"]
  #release_version = "${var.release_version}"
  #version = "${var.eks_cluster_version}" 

  remote_access {
    ec2_ssh_key = "${var.key_name}"
    source_security_group_ids = "${var.security_groups}"
  }

  #remote_access_security_group_id = "${var.security_groups}"

  scaling_config {
    desired_size = "${var.min_size}"
    min_size     = "${var.min_size}"
    max_size     = "${var.max_size}"
  }

  update_config {
    max_unavailable = "${var.max_unavailable}"
  }

  tags = {
    "Name" = "${var.eks_cluster_name}-ng"
    "default-info" = "${var.default-info}"
    "wavve-map" = "${var.wavve-map}"
    "wavve-cost" = "${var.wavve-cost}"
  }
}
