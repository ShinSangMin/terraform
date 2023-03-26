data "aws_iam_role" "ng_role" {
  name = "${var.ng_iam_role}"
}

resource "aws_launch_template" "ec2_template" {
  name = "${var.aws_launch_template_name}"


  block_device_mappings {
    device_name = "${var.device_name}"

    ebs {
      volume_size = "${var.volume_size}"
      volume_type = "${var.volume_type}"
      delete_on_termination = "${var.delete_on_termination}"
    }
  }

  image_id = "${var.image_id}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 2
  }

  network_interfaces {
    security_groups = "${var.security_groups}"
  }

  tag_specifications {
    resource_type = "instance"
    tags = "${var.tags}"
  }

  tag_specifications {
    resource_type = "volume"
    tags = "${var.tags}"
  }

  tag_specifications {
    resource_type = "network-interface"
    tags = "${var.tags}"
  }

  user_data = base64encode("${data.template_file.cloud_init.rendered}")
  update_default_version = true

  tags = {
    "Name" = "${var.eks_cluster_name}-ng"
    "default-info" = "${var.default-info}"
    "wavve-map" = "${var.wavve-map}"
    "wavve-cost" = "${var.wavve-cost}"
  }
  
}

resource "aws_eks_node_group" "eks_nodegroup" {
  cluster_name    = "${var.eks_cluster_name}"
  node_group_name = "${var.eks_nodegroup_name}"
  node_role_arn   = "${data.aws_iam_role.ng_role.arn}"
  subnet_ids      = "${var.eks_subnet_ids}"

  capacity_type = "ON_DEMAND"

  launch_template {
    name = "${aws_launch_template.ec2_template.name}"
    version = "$Latest"
    #version = "${aws_launch_template.ec2_template.update_default_version}"
    #version = "${aws_launch_template.ec2_template.default_version}"
  }

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



