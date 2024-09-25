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

# key_pair
locals {
  key_pair_directory  = "${local.environment}/${local.region}/key_pair"
  key_pair_yaml_files = fileset("${path.module}/${local.key_pair_directory}", "*.yaml")
  key_pair_id         = [for file in local.key_pair_yaml_files : split(".yaml", file)[0]]
  key_pair_config = {
    for file in local.key_pair_yaml_files :
    split(".yaml", file)[0] => yamldecode(file("${path.module}/${local.key_pair_directory}/${file}"))
  }
}

module "ec2" {
  source                               = "./modules/ec2"
  ec2_id_without_name                  = each.key
  for_each                             = { for file in local.instance_id : file => local.instance_config[file] }
  instance_count                       = try(each.value.instance_count, 1)
  ami                                  = try(module.launch_template[each.value.launch_template_filename].id, null) == null ? try(each.value.ami, null) : null
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
  launch_template         = try([{ for id in [module.launch_template[each.value.launch_template_filename].id] : "id" => id }], each.value.launch_template, {})

  maintenance_options_auto_recovery = try(each.value.maintenance_options_auto_recovery, null)

  metadata_options = try(each.value.metadata_options, {})

  network_interface = try(each.value.network_interface, {})

  enclaved_options_enabled = try(each.value.enclaved_options_enabled, null)

  private_dns_name_options = try(each.value.private_dns_name_options, {})

  ebs_block_device       = try(each.value.ebs_block_device, [])
  ephemeral_block_device = try(each.value.ephemeral_block_device, [])
  root_block_device      = try(each.value.root_block_device, {})

  depends_on = [module.launch_template]

}

module "key_pair" {
  source          = "./modules/key_pair"
  for_each        = { for file in local.key_pair_id : file => local.key_pair_config[file] }
  key_name        = try(each.value.key_name, null)
  key_name_prefix = try(each.value.key_name_prefix, null)
  public_key      = try(module.tls_private_key[each.key].public_key_openssh, each.value.public_key)
  tags            = try(each.value.tags, {})
  depends_on      = [module.tls_private_key]
}

# tls
locals {
  tls_directory  = "${local.environment}/${local.region}/tls_private_key"
  tls_yaml_files = fileset("${path.module}/${local.tls_directory}", "*.yaml")
  tls_id         = [for file in local.tls_yaml_files : split(".yaml", file)[0]]
  tls_config = {
    for file in local.tls_yaml_files :
    split(".yaml", file)[0] => yamldecode(file("${path.module}/${local.tls_directory}/${file}"))
  }
}


module "tls_private_key" {
  source    = "./modules/tls_private_key"
  for_each  = { for file in local.tls_id : file => local.tls_config[file] }
  algorithm = try(each.value.algorithm, null)
}

# s3
locals {
  s3_directory  = "${local.environment}/${local.region}/s3"
  s3_yaml_files = fileset("${path.module}/${local.s3_directory}", "*.yaml")
  s3_id         = [for file in local.s3_yaml_files : split(".yaml", file)[0]]
  s3_config = {
    for file in local.s3_yaml_files :
    split(".yaml", file)[0] => yamldecode(file("${path.module}/${local.s3_directory}/${file}"))
  }
}


module "s3" {
  source              = "./modules/s3"
  for_each            = { for file in local.s3_id : file => local.s3_config[file] }
  bucket              = try(each.value.bucket, null)
  bucket_prefix       = try(each.value.bucket_prefix, null)
  force_destroy       = try(each.value.force_destroy, null)
  object_lock_enabled = try(each.value.object_lock_enabled, null)

  tags = try(each.value.tags, {})
}

# launch_template
locals {
  launch_template_directory  = "${local.environment}/${local.region}/launch_template"
  launch_template_yaml_files = fileset("${path.module}/${local.launch_template_directory}", "*.yaml")
  launch_template_id         = [for file in local.launch_template_yaml_files : split(".yaml", file)[0]]
  launch_template_config = {
    for file in local.launch_template_yaml_files :
    split(".yaml", file)[0] => yamldecode(file("${path.module}/${local.launch_template_directory}/${file}"))
  }
}


module "launch_template" {
  source                               = "./modules/launch_template"
  for_each                             = { for file in local.launch_template_id : file => local.launch_template_config[file] }
  block_device_mappings                = try(each.value.block_device_mappings, [])
  capacity_reservation_specification   = try(each.value.capacity_reservation_specification, {})
  cpu_options                          = try(each.value.cpu_options, {})
  credit_specification                 = try(each.value.credit_specification, {})
  default_version                      = try(each.value.default_version, null)
  description                          = try(each.value.description, null)
  disable_api_stop                     = try(each.value.disable_api_stop, null)
  disable_api_termination              = try(each.value.disable_api_termination, null)
  ebs_optimized                        = try(each.value.ebs_optimized, null)
  elastic_gpu_specifications           = try(each.value.elastic_gpu_specifications, {})
  elastic_inference_accelerator        = try(each.value.elastic_inference_accelerator, {})
  enclave_options                      = try(each.value.enclave_options, {})
  hibernation_options                  = try(each.value.hibernation_options, {})
  iam_instance_profile                 = try(each.value.iam_instance_profile, {})
  image_id                             = try(each.value.image_id, null)
  instance_initiated_shutdown_behavior = try(each.value.instance_initiated_shutdown_behavior, null)
  instance_market_options              = try(each.value.instance_market_options, {})
  instance_requirements                = try(each.value.instance_requirements, {})
  instance_type                        = try(each.value.instance_type, null)
  kernel_id                            = try(each.value.kernel_id, null)
  key_name                             = try(each.value.key_name, null)
  license_specification                = try(each.value.license_specification, [])
  maintenance_options                  = try(each.value.maintenance_options, {})
  metadata_options                     = try(each.value.metadata_options, {})
  monitoring                           = try(each.value.monitoring, {})
  name                                 = try(each.value.name, null)
  name_prefix                          = try(each.value.name_prefix, null)
  network_interfaces                   = try(each.value.network_interfaces, [])
  placement                            = try(each.value.placement, {})
  private_dns_name_options             = try(each.value.private_dns_name_options, {})
  ram_disk_id                          = try(each.value.ram_disk_id, null)
  security_group_names                 = try(each.value.security_group_names, null)
  tag_specifications                   = try(each.value.tag_specifications, [])
  tags                                 = try(each.value.tags, null)
  update_default_version               = try(each.value.update_default_version, null)
  user_data                            = try(each.value.user_data, null)
  vpc_security_group_ids               = try(each.value.vpc_security_group_ids, null)

}

# eip
locals {
  eip_directory  = "${local.environment}/${local.region}/eip"
  eip_yaml_files = fileset("${path.module}/${local.eip_directory}", "*.yaml")
  eip_id         = [for file in local.eip_yaml_files : split(".yaml", file)[0]]
  eip_config = {
    for file in local.eip_yaml_files :
    split(".yaml", file)[0] => yamldecode(file("${path.module}/${local.eip_directory}/${file}"))
  }
}


module "eip" {
  source                    = "./modules/eip"
  for_each                  = { for file in local.eip_id : file => local.eip_config[file] }
  eip_filename              = each.key
  address                   = try(each.value.address, null)
  associate_with_private_ip = try(each.value.associate_with_private_ip, null)
  customer_owned_ipv4_pool  = try(each.value.customer_owned_ipv4_pool, null)
  domain                    = try(each.value.domain, null)
  instance                  = try(module.ec2[each.value.instance_filename].id, each.value.instance, null)
  network_border_group      = try(each.value.network_border_group, null)
  network_interface         = try(each.value.network_interface, null)
  public_ipv4_pool          = try(each.value.public_ipv4_pool, null)
  tags                      = try(each.value.tags, null)
  depends_on                = [module.ec2]
}

