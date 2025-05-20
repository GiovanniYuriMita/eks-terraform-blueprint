module "eks" {
  source                         = "terraform-aws-modules/eks/aws"
  version                        = "~> 20.24.1"
  cluster_name                   = var.cluster_name
  subnet_ids                     = var.subnets
  vpc_id                         = var.vpc_id
  cluster_version                = var.eks_k8s_version
  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
      before_compute = true
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
  }

  eks_managed_node_groups = {
    for env in var.node_groups : 
    env.name => {
      name                       = env.name
      min_size                   = env.min_size
      max_size                   = env.max_size
      desired_size               = env.desired_size
      instance_types             = env.instance_types
      capacity_type              = env.capacity_type
      ami_type                   = env.ami_type
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = var.ebs_disk_size
            volume_type           = var.ebs_volume_type
            delete_on_termination = true
            encrypted             = var.ebs_is_encrypted
          }
        }
      }
      launch_template_version    = "$Latest"
      iam_role_name              = "${env.name}-Worker-Role"
      iam_role_additional_policies = env.additional_iam_policies
      labels = {
        env = env.label
      }
      lifecycle = {
        create_before_destroy = true
      }
    }
  }

  ### IAM Role ###
  create_iam_role = true
  iam_role_name = "${var.cluster_name}-Node-Role"

  enable_cluster_creator_admin_permissions = true

  tags = {
    Name      = var.cluster_name
    ManagedBy = "terraform"
  }
}

data "aws_autoscaling_groups" "node_groups" {
  for_each = { for ng in var.node_groups : ng.name => ng }

  filter {
    name   = "tag:eks:cluster-name"
    values = [var.cluster_name]
  }

  filter {
    name   = "tag:eks:nodegroup-name"
    values = [each.value.name]
  }
}

# Create scheduled scaling actions
resource "aws_autoscaling_schedule" "scheduled_scaling" {
  for_each = { 
    for action in var.scheduled_autoscaling_actions : 
    "${action.node_group_name}.${action.scheduled_action_name}" => action
    if contains(keys(module.eks.eks_managed_node_groups), action.node_group_name)
  }

  scheduled_action_name  = each.value.scheduled_action_name
  autoscaling_group_name = module.eks.eks_managed_node_groups[each.value.node_group_name].node_group_autoscaling_group_names[0]
  desired_capacity       = try(each.value.desired_capacity, null)
  min_size               = try(each.value.min_size, null)
  max_size               = try(each.value.max_size, null)
  recurrence             = try(each.value.recurrence, null)
  start_time             = try(each.value.start_time, null)
  time_zone              = each.value.time_zone

  depends_on = [module.eks]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name

  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name

  depends_on = [module.eks]
}
