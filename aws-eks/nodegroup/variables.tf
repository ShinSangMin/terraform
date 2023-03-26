# variable "name" {
#     type = string
# }
variable "device_name" {
    type = string
}
variable "volume_size" {
    type = string
}
variable "volume_type" {
    type = string
}
variable "delete_on_termination" {
    type = bool
}
# variable "cluster_name" {
#     type = string
# }
# variable "nodegroup_name" {
#     type = string
# }
# variable "nodepool_role" {
#     type = string
# }
variable "eks_cluster_dns" {
    type = string
}
variable "instance_type" {
    type = string
}
# variable "image_id" {
#     type = string
# }
variable "key_name" {
    type = string
}
variable "security_groups" {
    type = list
}
#variable "tag_specifications_tags" {
#    type = map
#}
variable "tags" {
    type = map
}
variable "eks_nodegroup_name" {
    type = string
}
variable "eks_cluster_name" {
    type = string
}
# variable "eks_cluster_version" {
#    type = string
# }
variable "eks_subnet_ids" {
    type = list
}
variable "eks_source_security_groups" {
    type = list
}
# variable "aws_launch_template_name" {
#     type = string
# }
# variable "aws_launch_template_version" {
#     type = string
# }
# variable "ec2_ssh_key" {
#     type = string
# }
# variable "release_version" {
#     type = string
# }
variable "ng_iam_role" {
    type = string
}
# variable "disk_size" {
#     type = string
# }
# variable "instance_types" {
#     type = list
# }
variable "min_size" {
    type = string
}
variable "max_size" {
    type = string
}
variable "max_unavailable" {
    type = string
}
variable "default-info" {
    type = string
}
variable "wavve-map" {
    type = string
}
variable "wavve-cost" {
    type = string
}

