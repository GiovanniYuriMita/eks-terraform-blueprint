### AWS PARAMETERS ###
aws_region = "us-east-1"

### EKS PARAMETERS ###
cluster_name = ""
eks_k8s_version = "1.32"

### NODE PARAMETERS ###
# Node Group Configurations
node_groups = [
  {
    name                = "dev-node-group-on-demand"
    min_size            = 2
    max_size            = 5
    desired_size        = 3
    instance_types      = ["t3a.medium"]
    capacity_type       = "ON_DEMAND"
    ami_type            = "AL2_x86_64" # AL2_x86_64, AL2_x86_64_GPU, AL2_ARM_64, CUSTOM
    additional_iam_policies = {
      # Some-Policy      = "arn:aws:iam::883922500875:policy/Some-Policy",
    }
    label               = "dev"
  }
]

scheduled_autoscaling_actions = [
    ### DEV-GROUP ON-DEMAND: Scale Up at 7 AM and Scale down at 6 PM (Monday to Friday) ###
  # {
  #   node_group_name       = "dev-node-group-on-demand"
  #   scheduled_action_name = "scale-up-on-demand"
  #   desired_capacity      = 3
  #   min_size              = 2
  #   max_size              = 5
  #   recurrence            = "0 7 * * MON-FRI"
  #   time_zone             = "Brazil/West"
  # },
  # {
  #   node_group_name       = "dev-node-group-on-demand"
  #   scheduled_action_name = "scale-down-on-demand"
  #   desired_capacity      = 3
  #   min_size              = 2
  #   max_size              = 5
  #   recurrence            = "0 18 * * MON-FRI"
  #   time_zone             = "Brazil/West"
  # },
]

### EBS PARAMETERS ###
ebs_disk_size = 20 # GB
ebs_volume_type = "gp3"
ebs_is_encrypted = true

### NETWORK PARAMETERS ###
vpc_id = ""
subnets = [
    "",
    ""
]