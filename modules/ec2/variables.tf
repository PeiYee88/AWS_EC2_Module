variable "ids" {
  description = "List of EC2 instance ids"
  type        = any
  default     = []
}

variable "instance_count" {
  description = "Number of instances to be created"
  type        = number
  default     = 1
}

variable "ami" {
  description = "AMI to use for the instance"
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
  default     = null
}

variable "availability_zone" {
  description = "AZ to start the instance in"
  type        = string
  default     = null
}

variable "disable_api_stop" {
  description = "If true, enables EC2 Instance Stop Protection"
  type        = bool
  default     = null
}

variable "disable_api_termination" {
  description = "If true, enables EC2 Instance Termination Protection"
  type        = bool
  default     = null
}

variable "enclaved_options_enabled" {
  description = "Enable Nitro Enclaves on launched instances"
  type        = bool
  default     = null
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  type        = bool
  default     = null
}

variable "get_password_data" {
  description = "If true, wait for password data to become available and retrieve it"
  type        = bool
  default     = null
}

variable "hibernation" {
  description = "If true, the launched EC2 instance will support hibernation"
  type        = bool
  default     = null
}

variable "host_id" {
  description = " ID of a dedicated host that the instance will be assigned to"
  type        = string
  default     = null
}

variable "host_resource_group_arn" {
  description = "ARN of the host resource group in which to launch the instances"
  type        = string
  default     = null
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile to launch the instance with"
  type        = string
  default     = null
}

variable "instance_initiated_shutdown_behavior" {
  description = "Shutdown behavior for the instance"
  type        = string
  default     = null
}

variable "instance_type" {
  description = "Instance type to use for the instance"
  type        = string
  default     = null
}

variable "ipv6_address_count" {
  description = "Number of IPv6 addresses to associate with the primary network interface"
  type        = number
  default     = null
}

variable "ipv6_addesses" {
  description = "Specify one or more IPv6 addresses from the range of the subnet to associate with the primary network interface"
  type        = list(string)
  default     = null
}

variable "key_name" {
  description = "Key name of the Key Pair to use for the instance"
  type        = string
  default     = null
}

variable "maintenance_options_auto_recovery" {
  description = "Automatic recovery behavior of the instance"
  type        = string
  default     = null
}

variable "monitoring" {
  description = "If true, the launched EC2 instance will have detailed monitoring enabled"
  type        = bool
  default     = null
}

variable "placement_group" {
  description = "Placement Group to start the instance in"
  type        = string
  default     = null
}

variable "placement_partition_number" {
  description = "Number of the partition the instance is in"
  type        = number
  default     = null
}

variable "private_ip" {
  description = "Private IP address to associate with the instance in a VPC"
  type        = string
  default     = null
}

variable "secondary_private_ips" {
  description = "List of secondary private IPv4 addresses to assign to the instance's primary network interface (eth0) in a VPC"
  type        = set(string)
  default     = []
}

variable "security_groups" {
  description = "List of security group names to associate with"
  type        = set(string)
  default     = []
}

variable "source_dest_check" {
  description = " Controls if traffic is routed to the instance when the destination address does not match the instance"
  type        = bool
  default     = null
}

variable "subnet_id" {
  description = "VPC Subnet ID to launch in"
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "tenancy" {
  description = "Tenancy of the instance (if the instance is running in a VPC)"
  type        = string
  default     = null
}

variable "user_data" {
  description = "User data to provide when launching the instance"
  type        = string
  default     = null
}

variable "user_data_base64" {
  description = "Can be used instead of user_data to pass base64-encoded binary data directly"
  type        = string
  default     = null
}

variable "user_data_replace_on_change" {
  description = "When used in combination with user_data or user_data_base64 will trigger a destroy and recreate when set to true"
  type        = bool
  default     = null
}

variable "volume_tags" {
  description = "Map of tags to assign, at instance-creation time, to root and EBS volumes"
  type        = map(string)
  default     = {}
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to associate with"
  type        = set(string)
  default     = []
}

# Block variables
variable "capacity_reservation_specification" {
  description = "Describes an instance's Capacity Reservation targeting option"
  type        = any
  default     = {}
}

variable "cpu_options" {
  description = "The CPU options for the instance"
  type        = any
  default     = {}
}

variable "credit_specification" {
  description = "Configuration block for customizing the credit specification of the instance"
  type        = any
  default     = {}
}

variable "ebs_block_device" {
  description = "Additional EBS block devices to attach to the instance"
  type        = any
  default     = []
}

variable "ephemeral_block_device" {
  description = "One or more configuration blocks to customize Ephemeral volumes on the instance"
  type        = any
  default     = []
}

variable "instance_market_options" {
  description = "Describes the market (purchasing) option for the instances"
  type        = any
  default     = {}
}

variable "launch_template" {
  description = "Specifies a Launch Template to configure the instance"
  type        = any
  default     = {}
}

variable "metadata_options" {
  description = "Customize the metadata options of the instance"
  type        = any
  default     = {}
}

variable "network_interface" {
  description = "Customize network interfaces to be attached at instance boot time"
  type        = any
  default     = {}
}

variable "private_dns_name_options" {
  description = "Options for the instance hostname"
  type        = any
  default     = {}
}

variable "root_block_device" {
  description = "Configuration block to customize details about the root block device of the instance"
  type        = any
  default     = {}
}

variable "ec2_id_without_name" {
  description = "For resource indexing when ec2 instance do not have name"
  type        = string
  default     = null

}