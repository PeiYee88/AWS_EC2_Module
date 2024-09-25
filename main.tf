data "local_file" "config" {
  filename = "${path.module}/config.json"
}

locals {
  environment = jsondecode(data.local_file.region.content)["environment"]
  region      = jsondecode(data.local_file.region.content)["region"]
}

# ec2
locals {
  ec2_directory  = "${local.environment}/${local.region}/ec2"
  ec2_yaml_files = fileset("${path.module}/${local.ec2_directory}", "*.yaml")
  instance_id    = [for file in local.ec2_yaml_files : split(".yaml", file)[0]]
  instance_config = {
    for file in local.ec2_yaml_files :
    split(".yaml", file)[0] => yamldecode(file("${path.module}/${local.ec2_directory}/${file}"))
  }
}

module "ec2" {
  source                               = "./modules/ec2"
  ec2_id_without_name                  = each.key
  for_each                             = { for file in local.instance_id : file => local.instance_config[file] }
  instance_count                       = try(each.value.instance_count, 1)
  ami                                  = try(each.value.ami, null)
  instance_type                        = try(each.value.instance_type, "")
  associate_public_ip_address          = try(each.value.associate_public_ip_address, null)
  availability_zone                    = try(each.value.availability_zone, null)
  disable_api_stop                     = try(each.value.disable_api_stop, null)
  disable_api_termination              = try(each.value.disable_api_termination, null)
  ebs_optimized                        = try(each.value.ebs_optimized, null)
  get_password_data                    = try(each.value.get_password_data, null)
  hibernation                          = try(each.value.hibernation, null)
  host_id                              = try(each.value.host_id, null)
  host_resource_group_arn              = try(each.value.host_resource_group_arn, null)
  iam_instance_profile                 = try(each.value.iam_instance_profile, null)
  instance_initiated_shutdown_behavior = try(each.value.instance_initiated_shutdown_behavior, null)
  ipv6_address_count                   = try(each.value.ipv6_address_count, null)
  ipv6_addesses                        = try(each.value.ipv6_addresses, null) == [] ? null : try(each.value.ipv6_addresses, null)
  key_name                             = try(each.value.key_name, null)
  monitoring                           = try(each.value.monitoring, null) == "disabled" ? false : (try(each.value.monitoring, null) == "enabled" ? true : try(each.value.monitoring, null) )
  placement_group                      = try(each.value.placement_group, null)
  placement_partition_number           = try(each.value.placement_partition_number, null)
  private_ip                           = try(each.value.private_ip, null)
  secondary_private_ips                = try(each.value.secondary_private_ips, null)
  security_groups                      = try(each.value.security_groups, null)
  source_dest_check                    = try(each.value.source_dest_check, null)
  subnet_id                            = try(each.value.subnet_id, null)
  tags                                 = try(each.value.tags, null)
  tenancy                              = try(each.value.tenancy, null)
  user_data                            = try(each.value.user_data, null)
  user_data_base64                     = try(each.value.user_data_base64, null)
  user_data_replace_on_change          = try(each.value.user_data_replace_on_change, null)
  volume_tags                          = try(each.value.volume_tags, null)
  vpc_security_group_ids               = try(each.value.vpc_security_group_ids, null)


  cpu_options = try(each.value.cpu_options, {})

  capacity_reservation_specification = try(each.value.capacity_reservation_specification, {})

  credit_specification = try(each.value.credit_specification, {})

  instance_market_options = try(each.value.instance_market_options, {})
  launch_template         = try(each.value.launch_template, null)

  maintenance_options_auto_recovery = try(each.value.maintenance_options_auto_recovery, null)

  metadata_options = try(each.value.metadata_options, {})

  network_interface = try(each.value.network_interface, {})

  enclaved_options_enabled = try(each.value.enclaved_options_enabled, null)

  private_dns_name_options = try(each.value.private_dns_name_options, {})

  ebs_block_device       = try(each.value.ebs_block_device, [])
  ephemeral_block_device = try(each.value.ephemeral_block_device, [])
  root_block_device      = try(each.value.root_block_device, {})

}