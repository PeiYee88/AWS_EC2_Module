output "arn" {
  description = "The ARN of the instance."
  value       = try(aws_instance.this[var.tags.Name].arn, null)
}

output "capacity_reservation_specification" {
  description = "Capacity reservation specification of the instance."
  value       = try(aws_instance.this[var.tags.Name].capacity_reservation_specification, null)
}

output "id" {
  description = "The ID of the instance."
  value       = try(aws_instance.this[var.tags.Name].id, null)
}

output "instance_state" {
  description = "The current state of the instance."
  value       = try(aws_instance.this[var.tags.Name].instance_state, null)
}

output "outpost_arn" {
  description = "The ARN of the Outpost the instance is assigned to."
  value       = try(aws_instance.this[var.tags.Name].outpost_arn, null)
}

output "password_data" {
  description = "Base-64 encoded encrypted password data for the instance."
  value       = try(aws_instance.this[var.tags.Name].password_data, null)
}

output "primary_network_interface_id" {
  description = "The ID of the instance's primary network interface."
  value       = try(aws_instance.this[var.tags.Name].primary_network_interface_id, null)
}

output "private_dns" {
  description = "Private DNS name assigned to the instance."
  value       = try(aws_instance.this[var.tags.Name].private_dns, null)
}

output "public_dns" {
  description = "Public DNS name assigned to the instance."
  value       = try(aws_instance.this[var.tags.Name].public_dns, null)
}

output "public_ip" {
  description = "Public IP address assigned to the instance, if applicable."
  value       = try(aws_instance.this[var.tags.Name].public_ip, null)
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including inherited tags."
  value       = try(aws_instance.this[var.tags.Name].tags_all, null)
}

output "ebs_block_device_volume_id" {
  description = "ID of the volume"
  value       = try(aws_instance.this[var.tags.Name].ebs_block_device[*].volume_id, null)
}

output "ebs_block_device_tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = try(aws_instance.this[var.tags.Name].ebs_block_device[*].tags_all, null)
}

output "root_block_device_volume_id" {
  description = "ID of the volume"
  value       = try(aws_instance.this[var.tags.Name].root_block_device[*].volume_id, null)
}

output "root_block_device_device_name" {
  description = "Device name"
  value       = try(aws_instance.this[var.tags.Name].root_block_device[*].device_name, null)
}

output "root_block_device_tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = try(aws_instance.this[var.tags.Name].root_block_device[*].tags_all, null)
}

output "instance_market_options_instance_lifecycle" {
  description = "Indicates whether this is a Spot Instance or a Scheduled Instance"
  value       = try(aws_instance.this[var.tags.Name].instance_market_options[0].instance_lifecycle, null)
}

output "instance_market_options_spot_instance_request_id" {
  description = "Indicates whether this is a Spot Instance or a Scheduled Instance If the request is a Spot Instance request, the ID of the request."
  value       = try(aws_instance.this[var.tags.Name].instance_market_options[0].spot_instance_request_id, null)
}

