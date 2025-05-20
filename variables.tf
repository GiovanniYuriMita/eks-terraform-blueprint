### AWS PARAMETERS ###
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
}

### EKS PARAMETERS ###
variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}
variable "eks_k8s_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
}

### NODE PARAMETERS ###
# Node Group Configurations
variable "node_groups" {
  type = list(object({
    name               = string
    min_size           = number
    max_size           = number
    desired_size       = number
    instance_types     = list(string)
    capacity_type      = string
    ami_type           = string
    label              = string
    additional_iam_policies = map(string)
  }))
}
variable "scheduled_autoscaling_actions" {
  description = "List of scheduled actions to adjust autoscaling group parameters"
  type = list(object({
    node_group_name       = string
    scheduled_action_name = string
    desired_capacity      = optional(number)
    min_size              = optional(number)
    max_size              = optional(number)
    recurrence            = optional(string)  # Cron expression (e.g., "0 9 * * MON-FRI")
    start_time            = optional(string)  # ISO 8601 format (e.g., "2025-04-25T08:00:00Z")
    time_zone             = optional(string)  # IANA timezone (e.g., "America/New_York")
  }))
  default = []
}

### EBS PARAMETERS ###
variable "ebs_disk_size" {
  description = "The size of the EBS volume in GB"
  type        = number
}
variable "ebs_volume_type" {
  description = "The type of the EBS volume"
  type        = string
}
variable "ebs_is_encrypted" {
  description = "Whether the EBS volume should be encrypted"
  type        = bool
}

### NETWORK PARAMETERS ###
variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}
variable "subnets" {
  description = "List of subnet IDs"
  type        = list(string)
}