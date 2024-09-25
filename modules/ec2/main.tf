resource "aws_instance" "this" {
  for_each                             = length(toset(var.ids)) > 0 ? toset(var.ids) : (var.instance_count == 1 ? toset(["${try(var.tags.Name, var.ec2_id_without_name)}"]) : [for i in range(var.instance_count) : "${try(var.tags.Name, var.ec2_id_without_name)}-${i + 1}"])
  ami                                  = var.ami
  associate_public_ip_address          = var.associate_public_ip_address
  availability_zone                    = var.availability_zone
  disable_api_stop                     = var.disable_api_stop
  disable_api_termination              = var.disable_api_termination
  ebs_optimized                        = var.ebs_optimized
  get_password_data                    = var.get_password_data
  hibernation                          = var.hibernation
  host_id                              = var.host_id
  host_resource_group_arn              = var.host_resource_group_arn
  iam_instance_profile                 = var.iam_instance_profile
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  instance_type                        = var.instance_type
  ipv6_address_count                   = var.ipv6_address_count
  ipv6_addresses                       = var.ipv6_addesses
  key_name                             = var.key_name
  monitoring                           = var.monitoring
  placement_group                      = var.placement_group
  placement_partition_number           = var.placement_partition_number
  private_ip                           = var.private_ip
  secondary_private_ips                = var.secondary_private_ips
  security_groups                      = var.security_groups
  source_dest_check                    = var.source_dest_check
  subnet_id                            = var.subnet_id

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      user_data, 
      user_data_replace_on_change
    ]

  }

  tags = (var.instance_count == 1 ? var.tags : {
    for k, v in var.tags : k => (
      k == "Name" && var.instance_count > 1 ? each.key : v
    )
  })

  tenancy                     = var.tenancy
  user_data                   = var.user_data
  user_data_base64            = var.user_data_base64
  user_data_replace_on_change = var.user_data_replace_on_change
  volume_tags                 = var.volume_tags
  vpc_security_group_ids      = var.vpc_security_group_ids


  dynamic "capacity_reservation_specification" {
    for_each = try(var.capacity_reservation_specification, {})

    content {
      capacity_reservation_preference = try(capacity_reservation_specification.value.capacity_reservation_preference, null)

      dynamic "capacity_reservation_target" {
        for_each = try(capacity_reservation_specification.value.capacity_reservation_target, {})

        content {
          capacity_reservation_id                 = try(capacity_reservation_target.value.capacity_reservation_id, null)
          capacity_reservation_resource_group_arn = try(capacity_reservation_target.value.capacity_reservation_resource_group_arn, null)
        }
      }
    }
  }


  dynamic "cpu_options" {
    for_each = try(var.cpu_options, {})

    content {
      amd_sev_snp      = try(cpu_options.value.amd_sev_snp, null) == "" ? "disabled" : null
      core_count       = try(cpu_options.value.core_count, null)
      threads_per_core = try(cpu_options.value.threads_per_core, null)
    }
  }


  dynamic "credit_specification" {
    for_each = try(var.credit_specification, {})

    content {
      cpu_credits = try(credit_specification.value.cpu_credits, null)
    }
  }


  dynamic "ebs_block_device" {
    for_each = try(var.ebs_block_device, [])

    content {
      delete_on_termination = try(ebs_block_device.value.delete_on_termination, null)
      device_name           = ebs_block_device.value.device_name
      encrypted             = try(ebs_block_device.value.encrypted, null)
      iops                  = try(ebs_block_device.value.iops, null)
      kms_key_id            = try(ebs_block_device.value.kms_key_id, null)
      snapshot_id           = try(ebs_block_device.value.snapshot_id, null)
      throughput            = try(ebs_block_device.value.throughput, null)
      tags                  = try(ebs_block_device.value.tags, null)
      volume_size           = try(ebs_block_device.value.volume_size, null)
      volume_type           = try(ebs_block_device.value.volume_type, null)
    }
  }


  enclave_options {
    enabled = try(var.enclaved_options_enabled, null)
  }

  dynamic "ephemeral_block_device" {
    for_each = try(var.ephemeral_block_device, [])

    content {
      device_name  = ephemeral_block_device.value.device_name
      no_device    = try(ephemeral_block_device.value.no_device, null)
      virtual_name = try(ephemeral_block_device.value.virtual_name, null)
    }
  }


  dynamic "instance_market_options" {
    for_each = try(var.instance_market_options, {})

    content {
      market_type = try(instance_market_options.value.market_type, null)

      dynamic "spot_options" {
        for_each = try(instance_market_options.value.spot_options, {})

        content {
          instance_interruption_behavior = try(spot_options.value.instance_initiated_shutdown_behavior, null)
          max_price                      = try(spot_options.value.max_price, null)
          spot_instance_type             = try(spot_options.value.spot_instance_type, null)
          valid_until                    = try(spot_options.value.valid_until, null)
        }
      }
    }
  }

  dynamic "launch_template" {
    for_each = try(var.launch_template, null)
    content {
      id      = try(launch_template.value.id, null)
      name    = try(launch_template.value.id, null) == null ? try(launch_template.value.name, null) : null
      version = try(launch_template.value.version, null)
    }
  }

  maintenance_options {
    auto_recovery = var.maintenance_options_auto_recovery
  }


  dynamic "metadata_options" {
    for_each = try(var.metadata_options, {})

    content {
      http_endpoint               = try(metadata_options.value.http_endpoint, "enabled")
      http_protocol_ipv6          = try(metadata_options.value.http_protocol_ipv6, "disabled")
      http_tokens                 = try(metadata_options.value.http_tokens, "optional")
      http_put_response_hop_limit = try(metadata_options.value.http_put_response_hop_limit, 1)
      instance_metadata_tags      = try(metadata_options.value.instance_metadata_tags, null)
    }
  }


  dynamic "network_interface" {
    for_each = try(var.network_interface, {})

    content {
      delete_on_termination = try(network_interface.value.delete_on_termination, false)
      device_index          = try(network_interface.value.device_index, null)
      network_card_index    = try(network_interface.value.network_card_index, null)
      network_interface_id  = try(network_interface.value.network_interface_id, null)
    }
  }


  dynamic "private_dns_name_options" {
    for_each = try(var.private_dns_name_options, {})

    content {
      enable_resource_name_dns_a_record    = try(private_dns_name_options.value.enable_resource_name_dns_a_record, null)
      enable_resource_name_dns_aaaa_record = try(private_dns_name_options.value.enable_resource_name_dns_aaaa_record, null)
      hostname_type                        = try(private_dns_name_options.value.hostname_type, null)
    }
  }


  dynamic "root_block_device" {
    for_each = try(var.root_block_device, {})

    content {
      delete_on_termination = try(root_block_device.value.delete_on_termination, null)
      encrypted             = try(root_block_device.value.encrypted, null)
      iops                  = try(root_block_device.value.iops, null)
      kms_key_id            = try(root_block_device.value.kms_key_id, null)
      throughput            = try(root_block_device.value.throughput, null)
      tags                  = try(root_block_device.value.tags, null)
      volume_size           = try(root_block_device.value.volume_size, null)
      volume_type           = try(root_block_device.value.volume_type, null)
    }
  }
}

