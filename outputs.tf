# Copyright 2025 Automate the Cloud Inc.
# SPDX-License-Identifier: Apache-2.0

output "metadata" {
  description = <<-EOT
    Everything the module created, in one object, so that other configurations need only one reference. Each resource entry lists that resource's attributes, such as `id` and `arn`; an entry is `null` when the resource is not created.

    - `details` - The scope, purpose and environment, each with its `name`, `abbr` (lowercase, words joined by underscores) and `machine` (lowercase letters and numbers only) forms, and the `tags` applied to every resource.
    - `aws` - The `account.id`, and the `region` `name`, `abbr` (such as `use1` for `us-east-1`) and `description`.
    - `vpc` - The VPC, such as `id`, `cidr_block` and `ipv6_cidr_block`, plus the VPC name's `name`, `abbr` and `machine` forms.
    - `subnet` - The subnets by tier: `private`, `restricted` and `public`. Each tier has `ids`, a list of its three subnet IDs in Availability Zone order, and `1`, `2` and `3`, one subnet each.
    - `route_table` - The route tables, one per subnet, in the same shape as `subnet`.
    - `network_acl` - The network ACLs, one per tier: `private`, `restricted` and `public`.
    - `db_subnet_group`, `elasticache_subnet_group` - The DB and ElastiCache subnet groups, one per tier, such as `db_subnet_group.private.name`.
    - `vpc_endpoint` - The `s3` and `dynamodb` gateway endpoints.
    - `internet_gateway` - The internet gateway.
    - `egress_only_internet_gateway` - The egress-only internet gateway, created when `enable_ipv6` is `true`.
    - `kms_key`, `kms_alias` - The data key and its alias, created when `enable_kms_key_data` is `true`.
    - `flow_log` - The flow log, created when `flow_log` is set.
    - `default_network_acl`, `default_route_table`, `default_security_group` - The VPC's default network ACL, route table and security group. No subnet uses them. The module removes every rule from the default network ACL and security group, and tags all three `DO NOT USE OR MODIFY`.
  EOT
  value = {
    details = {
      scope = {
        name    = local.scope.name
        abbr    = local.scope.abbr
        machine = local.scope.machine
      }
      purpose = {
        name    = local.purpose.name
        abbr    = local.purpose.abbr
        machine = local.purpose.machine
      }
      environment = {
        name    = local.environment.name
        abbr    = local.environment.abbr
        machine = local.environment.machine
      }
      tags = local.tags
    }

    aws = {
      account = {
        id = local.aws.account.id
      }
      region = {
        name        = local.aws.region.name
        abbr        = local.aws.region.abbr
        description = local.aws.region.description
      }
    }

    # One entry per resource, each attribute listed one by one. Referencing a whole
    # resource would also reference its deprecated attributes, and every caller's plan
    # would print deprecation warnings.
    db_subnet_group = {
      private = {
        arn                     = aws_db_subnet_group.private.arn
        description             = aws_db_subnet_group.private.description
        id                      = aws_db_subnet_group.private.id
        name                    = aws_db_subnet_group.private.name
        name_prefix             = aws_db_subnet_group.private.name_prefix
        region                  = aws_db_subnet_group.private.region
        subnet_ids              = aws_db_subnet_group.private.subnet_ids
        supported_network_types = aws_db_subnet_group.private.supported_network_types
        tags                    = aws_db_subnet_group.private.tags
        tags_all                = aws_db_subnet_group.private.tags_all
        vpc_id                  = aws_db_subnet_group.private.vpc_id
      }
      restricted = {
        arn                     = aws_db_subnet_group.restricted.arn
        description             = aws_db_subnet_group.restricted.description
        id                      = aws_db_subnet_group.restricted.id
        name                    = aws_db_subnet_group.restricted.name
        name_prefix             = aws_db_subnet_group.restricted.name_prefix
        region                  = aws_db_subnet_group.restricted.region
        subnet_ids              = aws_db_subnet_group.restricted.subnet_ids
        supported_network_types = aws_db_subnet_group.restricted.supported_network_types
        tags                    = aws_db_subnet_group.restricted.tags
        tags_all                = aws_db_subnet_group.restricted.tags_all
        vpc_id                  = aws_db_subnet_group.restricted.vpc_id
      }
      public = {
        arn                     = aws_db_subnet_group.public.arn
        description             = aws_db_subnet_group.public.description
        id                      = aws_db_subnet_group.public.id
        name                    = aws_db_subnet_group.public.name
        name_prefix             = aws_db_subnet_group.public.name_prefix
        region                  = aws_db_subnet_group.public.region
        subnet_ids              = aws_db_subnet_group.public.subnet_ids
        supported_network_types = aws_db_subnet_group.public.supported_network_types
        tags                    = aws_db_subnet_group.public.tags
        tags_all                = aws_db_subnet_group.public.tags_all
        vpc_id                  = aws_db_subnet_group.public.vpc_id
      }
    }

    default_network_acl = {
      arn                    = aws_default_network_acl.this.arn
      default_network_acl_id = aws_default_network_acl.this.default_network_acl_id
      egress                 = aws_default_network_acl.this.egress
      id                     = aws_default_network_acl.this.id
      ingress                = aws_default_network_acl.this.ingress
      owner_id               = aws_default_network_acl.this.owner_id
      region                 = aws_default_network_acl.this.region
      subnet_ids             = aws_default_network_acl.this.subnet_ids
      tags                   = aws_default_network_acl.this.tags
      tags_all               = aws_default_network_acl.this.tags_all
      vpc_id                 = aws_default_network_acl.this.vpc_id
    }

    default_route_table = {
      arn                    = aws_default_route_table.this.arn
      default_route_table_id = aws_default_route_table.this.default_route_table_id
      id                     = aws_default_route_table.this.id
      owner_id               = aws_default_route_table.this.owner_id
      propagating_vgws       = aws_default_route_table.this.propagating_vgws
      region                 = aws_default_route_table.this.region
      route                  = aws_default_route_table.this.route
      tags                   = aws_default_route_table.this.tags
      tags_all               = aws_default_route_table.this.tags_all
      vpc_id                 = aws_default_route_table.this.vpc_id
    }

    default_security_group = {
      arn                    = aws_default_security_group.this.arn
      description            = aws_default_security_group.this.description
      egress                 = aws_default_security_group.this.egress
      id                     = aws_default_security_group.this.id
      ingress                = aws_default_security_group.this.ingress
      name                   = aws_default_security_group.this.name
      name_prefix            = aws_default_security_group.this.name_prefix
      owner_id               = aws_default_security_group.this.owner_id
      region                 = aws_default_security_group.this.region
      revoke_rules_on_delete = aws_default_security_group.this.revoke_rules_on_delete
      tags                   = aws_default_security_group.this.tags
      tags_all               = aws_default_security_group.this.tags_all
      vpc_id                 = aws_default_security_group.this.vpc_id
    }

    egress_only_internet_gateway = length(aws_egress_only_internet_gateway.this) == 0 ? null : {
      id       = aws_egress_only_internet_gateway.this[0].id
      region   = aws_egress_only_internet_gateway.this[0].region
      tags     = aws_egress_only_internet_gateway.this[0].tags
      tags_all = aws_egress_only_internet_gateway.this[0].tags_all
      vpc_id   = aws_egress_only_internet_gateway.this[0].vpc_id
    }

    elasticache_subnet_group = {
      private = {
        arn         = aws_elasticache_subnet_group.private.arn
        description = aws_elasticache_subnet_group.private.description
        id          = aws_elasticache_subnet_group.private.id
        name        = aws_elasticache_subnet_group.private.name
        region      = aws_elasticache_subnet_group.private.region
        subnet_ids  = aws_elasticache_subnet_group.private.subnet_ids
        tags        = aws_elasticache_subnet_group.private.tags
        tags_all    = aws_elasticache_subnet_group.private.tags_all
        vpc_id      = aws_elasticache_subnet_group.private.vpc_id
      }
      restricted = {
        arn         = aws_elasticache_subnet_group.restricted.arn
        description = aws_elasticache_subnet_group.restricted.description
        id          = aws_elasticache_subnet_group.restricted.id
        name        = aws_elasticache_subnet_group.restricted.name
        region      = aws_elasticache_subnet_group.restricted.region
        subnet_ids  = aws_elasticache_subnet_group.restricted.subnet_ids
        tags        = aws_elasticache_subnet_group.restricted.tags
        tags_all    = aws_elasticache_subnet_group.restricted.tags_all
        vpc_id      = aws_elasticache_subnet_group.restricted.vpc_id
      }
      public = {
        arn         = aws_elasticache_subnet_group.public.arn
        description = aws_elasticache_subnet_group.public.description
        id          = aws_elasticache_subnet_group.public.id
        name        = aws_elasticache_subnet_group.public.name
        region      = aws_elasticache_subnet_group.public.region
        subnet_ids  = aws_elasticache_subnet_group.public.subnet_ids
        tags        = aws_elasticache_subnet_group.public.tags
        tags_all    = aws_elasticache_subnet_group.public.tags_all
        vpc_id      = aws_elasticache_subnet_group.public.vpc_id
      }
    }

    flow_log = length(aws_flow_log.s3) == 0 ? null : {
      arn                           = aws_flow_log.s3[0].arn
      deliver_cross_account_role    = aws_flow_log.s3[0].deliver_cross_account_role
      destination_options           = aws_flow_log.s3[0].destination_options
      eni_id                        = aws_flow_log.s3[0].eni_id
      iam_role_arn                  = aws_flow_log.s3[0].iam_role_arn
      id                            = aws_flow_log.s3[0].id
      log_destination               = aws_flow_log.s3[0].log_destination
      log_destination_type          = aws_flow_log.s3[0].log_destination_type
      log_format                    = aws_flow_log.s3[0].log_format
      max_aggregation_interval      = aws_flow_log.s3[0].max_aggregation_interval
      region                        = aws_flow_log.s3[0].region
      subnet_id                     = aws_flow_log.s3[0].subnet_id
      tags                          = aws_flow_log.s3[0].tags
      tags_all                      = aws_flow_log.s3[0].tags_all
      traffic_type                  = aws_flow_log.s3[0].traffic_type
      transit_gateway_attachment_id = aws_flow_log.s3[0].transit_gateway_attachment_id
      transit_gateway_id            = aws_flow_log.s3[0].transit_gateway_id
      vpc_id                        = aws_flow_log.s3[0].vpc_id
    }

    internet_gateway = {
      arn      = aws_internet_gateway.this.arn
      id       = aws_internet_gateway.this.id
      owner_id = aws_internet_gateway.this.owner_id
      region   = aws_internet_gateway.this.region
      tags     = aws_internet_gateway.this.tags
      tags_all = aws_internet_gateway.this.tags_all
      vpc_id   = aws_internet_gateway.this.vpc_id
    }

    kms_alias = length(aws_kms_alias.this) == 0 ? null : {
      arn            = aws_kms_alias.this[0].arn
      id             = aws_kms_alias.this[0].id
      name           = aws_kms_alias.this[0].name
      name_prefix    = aws_kms_alias.this[0].name_prefix
      region         = aws_kms_alias.this[0].region
      target_key_arn = aws_kms_alias.this[0].target_key_arn
      target_key_id  = aws_kms_alias.this[0].target_key_id
    }

    kms_key = length(aws_kms_key.this) == 0 ? null : {
      arn                                = aws_kms_key.this[0].arn
      bypass_policy_lockout_safety_check = aws_kms_key.this[0].bypass_policy_lockout_safety_check
      custom_key_store_id                = aws_kms_key.this[0].custom_key_store_id
      customer_master_key_spec           = aws_kms_key.this[0].customer_master_key_spec
      deletion_window_in_days            = aws_kms_key.this[0].deletion_window_in_days
      description                        = aws_kms_key.this[0].description
      enable_key_rotation                = aws_kms_key.this[0].enable_key_rotation
      id                                 = aws_kms_key.this[0].id
      is_enabled                         = aws_kms_key.this[0].is_enabled
      key_id                             = aws_kms_key.this[0].key_id
      key_usage                          = aws_kms_key.this[0].key_usage
      multi_region                       = aws_kms_key.this[0].multi_region
      policy                             = aws_kms_key.this[0].policy
      region                             = aws_kms_key.this[0].region
      rotation_period_in_days            = aws_kms_key.this[0].rotation_period_in_days
      tags                               = aws_kms_key.this[0].tags
      tags_all                           = aws_kms_key.this[0].tags_all
      xks_key_id                         = aws_kms_key.this[0].xks_key_id
    }

    network_acl = {
      private = {
        arn        = aws_network_acl.private.arn
        egress     = aws_network_acl.private.egress
        id         = aws_network_acl.private.id
        ingress    = aws_network_acl.private.ingress
        owner_id   = aws_network_acl.private.owner_id
        region     = aws_network_acl.private.region
        subnet_ids = aws_network_acl.private.subnet_ids
        tags       = aws_network_acl.private.tags
        tags_all   = aws_network_acl.private.tags_all
        vpc_id     = aws_network_acl.private.vpc_id
      }
      restricted = {
        arn        = aws_network_acl.restricted.arn
        egress     = aws_network_acl.restricted.egress
        id         = aws_network_acl.restricted.id
        ingress    = aws_network_acl.restricted.ingress
        owner_id   = aws_network_acl.restricted.owner_id
        region     = aws_network_acl.restricted.region
        subnet_ids = aws_network_acl.restricted.subnet_ids
        tags       = aws_network_acl.restricted.tags
        tags_all   = aws_network_acl.restricted.tags_all
        vpc_id     = aws_network_acl.restricted.vpc_id
      }
      public = {
        arn        = aws_network_acl.public.arn
        egress     = aws_network_acl.public.egress
        id         = aws_network_acl.public.id
        ingress    = aws_network_acl.public.ingress
        owner_id   = aws_network_acl.public.owner_id
        region     = aws_network_acl.public.region
        subnet_ids = aws_network_acl.public.subnet_ids
        tags       = aws_network_acl.public.tags
        tags_all   = aws_network_acl.public.tags_all
        vpc_id     = aws_network_acl.public.vpc_id
      }
    }

    route_table = {
      private = {
        ids = [
          aws_route_table.private-1.id,
          aws_route_table.private-2.id,
          aws_route_table.private-3.id,
        ]
        1 = {
          arn              = aws_route_table.private-1.arn
          id               = aws_route_table.private-1.id
          owner_id         = aws_route_table.private-1.owner_id
          propagating_vgws = aws_route_table.private-1.propagating_vgws
          region           = aws_route_table.private-1.region
          route            = aws_route_table.private-1.route
          tags             = aws_route_table.private-1.tags
          tags_all         = aws_route_table.private-1.tags_all
          vpc_id           = aws_route_table.private-1.vpc_id
        }
        2 = {
          arn              = aws_route_table.private-2.arn
          id               = aws_route_table.private-2.id
          owner_id         = aws_route_table.private-2.owner_id
          propagating_vgws = aws_route_table.private-2.propagating_vgws
          region           = aws_route_table.private-2.region
          route            = aws_route_table.private-2.route
          tags             = aws_route_table.private-2.tags
          tags_all         = aws_route_table.private-2.tags_all
          vpc_id           = aws_route_table.private-2.vpc_id
        }
        3 = {
          arn              = aws_route_table.private-3.arn
          id               = aws_route_table.private-3.id
          owner_id         = aws_route_table.private-3.owner_id
          propagating_vgws = aws_route_table.private-3.propagating_vgws
          region           = aws_route_table.private-3.region
          route            = aws_route_table.private-3.route
          tags             = aws_route_table.private-3.tags
          tags_all         = aws_route_table.private-3.tags_all
          vpc_id           = aws_route_table.private-3.vpc_id
        }
      }
      restricted = {
        ids = [
          aws_route_table.restricted-1.id,
          aws_route_table.restricted-2.id,
          aws_route_table.restricted-3.id,
        ]
        1 = {
          arn              = aws_route_table.restricted-1.arn
          id               = aws_route_table.restricted-1.id
          owner_id         = aws_route_table.restricted-1.owner_id
          propagating_vgws = aws_route_table.restricted-1.propagating_vgws
          region           = aws_route_table.restricted-1.region
          route            = aws_route_table.restricted-1.route
          tags             = aws_route_table.restricted-1.tags
          tags_all         = aws_route_table.restricted-1.tags_all
          vpc_id           = aws_route_table.restricted-1.vpc_id
        }
        2 = {
          arn              = aws_route_table.restricted-2.arn
          id               = aws_route_table.restricted-2.id
          owner_id         = aws_route_table.restricted-2.owner_id
          propagating_vgws = aws_route_table.restricted-2.propagating_vgws
          region           = aws_route_table.restricted-2.region
          route            = aws_route_table.restricted-2.route
          tags             = aws_route_table.restricted-2.tags
          tags_all         = aws_route_table.restricted-2.tags_all
          vpc_id           = aws_route_table.restricted-2.vpc_id
        }
        3 = {
          arn              = aws_route_table.restricted-3.arn
          id               = aws_route_table.restricted-3.id
          owner_id         = aws_route_table.restricted-3.owner_id
          propagating_vgws = aws_route_table.restricted-3.propagating_vgws
          region           = aws_route_table.restricted-3.region
          route            = aws_route_table.restricted-3.route
          tags             = aws_route_table.restricted-3.tags
          tags_all         = aws_route_table.restricted-3.tags_all
          vpc_id           = aws_route_table.restricted-3.vpc_id
        }
      }
      public = {
        ids = [
          aws_route_table.public-1.id,
          aws_route_table.public-2.id,
          aws_route_table.public-3.id,
        ]
        1 = {
          arn              = aws_route_table.public-1.arn
          id               = aws_route_table.public-1.id
          owner_id         = aws_route_table.public-1.owner_id
          propagating_vgws = aws_route_table.public-1.propagating_vgws
          region           = aws_route_table.public-1.region
          route            = aws_route_table.public-1.route
          tags             = aws_route_table.public-1.tags
          tags_all         = aws_route_table.public-1.tags_all
          vpc_id           = aws_route_table.public-1.vpc_id
        }
        2 = {
          arn              = aws_route_table.public-2.arn
          id               = aws_route_table.public-2.id
          owner_id         = aws_route_table.public-2.owner_id
          propagating_vgws = aws_route_table.public-2.propagating_vgws
          region           = aws_route_table.public-2.region
          route            = aws_route_table.public-2.route
          tags             = aws_route_table.public-2.tags
          tags_all         = aws_route_table.public-2.tags_all
          vpc_id           = aws_route_table.public-2.vpc_id
        }
        3 = {
          arn              = aws_route_table.public-3.arn
          id               = aws_route_table.public-3.id
          owner_id         = aws_route_table.public-3.owner_id
          propagating_vgws = aws_route_table.public-3.propagating_vgws
          region           = aws_route_table.public-3.region
          route            = aws_route_table.public-3.route
          tags             = aws_route_table.public-3.tags
          tags_all         = aws_route_table.public-3.tags_all
          vpc_id           = aws_route_table.public-3.vpc_id
        }
      }
    }

    subnet = {
      private = {
        ids = [
          aws_subnet.private-1.id,
          aws_subnet.private-2.id,
          aws_subnet.private-3.id,
        ]
        1 = {
          arn                                            = aws_subnet.private-1.arn
          assign_ipv6_address_on_creation                = aws_subnet.private-1.assign_ipv6_address_on_creation
          availability_zone                              = aws_subnet.private-1.availability_zone
          availability_zone_id                           = aws_subnet.private-1.availability_zone_id
          cidr_block                                     = aws_subnet.private-1.cidr_block
          customer_owned_ipv4_pool                       = aws_subnet.private-1.customer_owned_ipv4_pool
          enable_dns64                                   = aws_subnet.private-1.enable_dns64
          enable_lni_at_device_index                     = aws_subnet.private-1.enable_lni_at_device_index
          enable_resource_name_dns_a_record_on_launch    = aws_subnet.private-1.enable_resource_name_dns_a_record_on_launch
          enable_resource_name_dns_aaaa_record_on_launch = aws_subnet.private-1.enable_resource_name_dns_aaaa_record_on_launch
          id                                             = aws_subnet.private-1.id
          ipv6_cidr_block                                = aws_subnet.private-1.ipv6_cidr_block
          ipv6_cidr_block_association_id                 = aws_subnet.private-1.ipv6_cidr_block_association_id
          ipv6_native                                    = aws_subnet.private-1.ipv6_native
          map_customer_owned_ip_on_launch                = aws_subnet.private-1.map_customer_owned_ip_on_launch
          map_public_ip_on_launch                        = aws_subnet.private-1.map_public_ip_on_launch
          outpost_arn                                    = aws_subnet.private-1.outpost_arn
          owner_id                                       = aws_subnet.private-1.owner_id
          private_dns_hostname_type_on_launch            = aws_subnet.private-1.private_dns_hostname_type_on_launch
          region                                         = aws_subnet.private-1.region
          tags                                           = aws_subnet.private-1.tags
          tags_all                                       = aws_subnet.private-1.tags_all
          vpc_id                                         = aws_subnet.private-1.vpc_id
        }
        2 = {
          arn                                            = aws_subnet.private-2.arn
          assign_ipv6_address_on_creation                = aws_subnet.private-2.assign_ipv6_address_on_creation
          availability_zone                              = aws_subnet.private-2.availability_zone
          availability_zone_id                           = aws_subnet.private-2.availability_zone_id
          cidr_block                                     = aws_subnet.private-2.cidr_block
          customer_owned_ipv4_pool                       = aws_subnet.private-2.customer_owned_ipv4_pool
          enable_dns64                                   = aws_subnet.private-2.enable_dns64
          enable_lni_at_device_index                     = aws_subnet.private-2.enable_lni_at_device_index
          enable_resource_name_dns_a_record_on_launch    = aws_subnet.private-2.enable_resource_name_dns_a_record_on_launch
          enable_resource_name_dns_aaaa_record_on_launch = aws_subnet.private-2.enable_resource_name_dns_aaaa_record_on_launch
          id                                             = aws_subnet.private-2.id
          ipv6_cidr_block                                = aws_subnet.private-2.ipv6_cidr_block
          ipv6_cidr_block_association_id                 = aws_subnet.private-2.ipv6_cidr_block_association_id
          ipv6_native                                    = aws_subnet.private-2.ipv6_native
          map_customer_owned_ip_on_launch                = aws_subnet.private-2.map_customer_owned_ip_on_launch
          map_public_ip_on_launch                        = aws_subnet.private-2.map_public_ip_on_launch
          outpost_arn                                    = aws_subnet.private-2.outpost_arn
          owner_id                                       = aws_subnet.private-2.owner_id
          private_dns_hostname_type_on_launch            = aws_subnet.private-2.private_dns_hostname_type_on_launch
          region                                         = aws_subnet.private-2.region
          tags                                           = aws_subnet.private-2.tags
          tags_all                                       = aws_subnet.private-2.tags_all
          vpc_id                                         = aws_subnet.private-2.vpc_id
        }
        3 = {
          arn                                            = aws_subnet.private-3.arn
          assign_ipv6_address_on_creation                = aws_subnet.private-3.assign_ipv6_address_on_creation
          availability_zone                              = aws_subnet.private-3.availability_zone
          availability_zone_id                           = aws_subnet.private-3.availability_zone_id
          cidr_block                                     = aws_subnet.private-3.cidr_block
          customer_owned_ipv4_pool                       = aws_subnet.private-3.customer_owned_ipv4_pool
          enable_dns64                                   = aws_subnet.private-3.enable_dns64
          enable_lni_at_device_index                     = aws_subnet.private-3.enable_lni_at_device_index
          enable_resource_name_dns_a_record_on_launch    = aws_subnet.private-3.enable_resource_name_dns_a_record_on_launch
          enable_resource_name_dns_aaaa_record_on_launch = aws_subnet.private-3.enable_resource_name_dns_aaaa_record_on_launch
          id                                             = aws_subnet.private-3.id
          ipv6_cidr_block                                = aws_subnet.private-3.ipv6_cidr_block
          ipv6_cidr_block_association_id                 = aws_subnet.private-3.ipv6_cidr_block_association_id
          ipv6_native                                    = aws_subnet.private-3.ipv6_native
          map_customer_owned_ip_on_launch                = aws_subnet.private-3.map_customer_owned_ip_on_launch
          map_public_ip_on_launch                        = aws_subnet.private-3.map_public_ip_on_launch
          outpost_arn                                    = aws_subnet.private-3.outpost_arn
          owner_id                                       = aws_subnet.private-3.owner_id
          private_dns_hostname_type_on_launch            = aws_subnet.private-3.private_dns_hostname_type_on_launch
          region                                         = aws_subnet.private-3.region
          tags                                           = aws_subnet.private-3.tags
          tags_all                                       = aws_subnet.private-3.tags_all
          vpc_id                                         = aws_subnet.private-3.vpc_id
        }
      }
      restricted = {
        ids = [
          aws_subnet.restricted-1.id,
          aws_subnet.restricted-2.id,
          aws_subnet.restricted-3.id,
        ]
        1 = {
          arn                                            = aws_subnet.restricted-1.arn
          assign_ipv6_address_on_creation                = aws_subnet.restricted-1.assign_ipv6_address_on_creation
          availability_zone                              = aws_subnet.restricted-1.availability_zone
          availability_zone_id                           = aws_subnet.restricted-1.availability_zone_id
          cidr_block                                     = aws_subnet.restricted-1.cidr_block
          customer_owned_ipv4_pool                       = aws_subnet.restricted-1.customer_owned_ipv4_pool
          enable_dns64                                   = aws_subnet.restricted-1.enable_dns64
          enable_lni_at_device_index                     = aws_subnet.restricted-1.enable_lni_at_device_index
          enable_resource_name_dns_a_record_on_launch    = aws_subnet.restricted-1.enable_resource_name_dns_a_record_on_launch
          enable_resource_name_dns_aaaa_record_on_launch = aws_subnet.restricted-1.enable_resource_name_dns_aaaa_record_on_launch
          id                                             = aws_subnet.restricted-1.id
          ipv6_cidr_block                                = aws_subnet.restricted-1.ipv6_cidr_block
          ipv6_cidr_block_association_id                 = aws_subnet.restricted-1.ipv6_cidr_block_association_id
          ipv6_native                                    = aws_subnet.restricted-1.ipv6_native
          map_customer_owned_ip_on_launch                = aws_subnet.restricted-1.map_customer_owned_ip_on_launch
          map_public_ip_on_launch                        = aws_subnet.restricted-1.map_public_ip_on_launch
          outpost_arn                                    = aws_subnet.restricted-1.outpost_arn
          owner_id                                       = aws_subnet.restricted-1.owner_id
          private_dns_hostname_type_on_launch            = aws_subnet.restricted-1.private_dns_hostname_type_on_launch
          region                                         = aws_subnet.restricted-1.region
          tags                                           = aws_subnet.restricted-1.tags
          tags_all                                       = aws_subnet.restricted-1.tags_all
          vpc_id                                         = aws_subnet.restricted-1.vpc_id
        }
        2 = {
          arn                                            = aws_subnet.restricted-2.arn
          assign_ipv6_address_on_creation                = aws_subnet.restricted-2.assign_ipv6_address_on_creation
          availability_zone                              = aws_subnet.restricted-2.availability_zone
          availability_zone_id                           = aws_subnet.restricted-2.availability_zone_id
          cidr_block                                     = aws_subnet.restricted-2.cidr_block
          customer_owned_ipv4_pool                       = aws_subnet.restricted-2.customer_owned_ipv4_pool
          enable_dns64                                   = aws_subnet.restricted-2.enable_dns64
          enable_lni_at_device_index                     = aws_subnet.restricted-2.enable_lni_at_device_index
          enable_resource_name_dns_a_record_on_launch    = aws_subnet.restricted-2.enable_resource_name_dns_a_record_on_launch
          enable_resource_name_dns_aaaa_record_on_launch = aws_subnet.restricted-2.enable_resource_name_dns_aaaa_record_on_launch
          id                                             = aws_subnet.restricted-2.id
          ipv6_cidr_block                                = aws_subnet.restricted-2.ipv6_cidr_block
          ipv6_cidr_block_association_id                 = aws_subnet.restricted-2.ipv6_cidr_block_association_id
          ipv6_native                                    = aws_subnet.restricted-2.ipv6_native
          map_customer_owned_ip_on_launch                = aws_subnet.restricted-2.map_customer_owned_ip_on_launch
          map_public_ip_on_launch                        = aws_subnet.restricted-2.map_public_ip_on_launch
          outpost_arn                                    = aws_subnet.restricted-2.outpost_arn
          owner_id                                       = aws_subnet.restricted-2.owner_id
          private_dns_hostname_type_on_launch            = aws_subnet.restricted-2.private_dns_hostname_type_on_launch
          region                                         = aws_subnet.restricted-2.region
          tags                                           = aws_subnet.restricted-2.tags
          tags_all                                       = aws_subnet.restricted-2.tags_all
          vpc_id                                         = aws_subnet.restricted-2.vpc_id
        }
        3 = {
          arn                                            = aws_subnet.restricted-3.arn
          assign_ipv6_address_on_creation                = aws_subnet.restricted-3.assign_ipv6_address_on_creation
          availability_zone                              = aws_subnet.restricted-3.availability_zone
          availability_zone_id                           = aws_subnet.restricted-3.availability_zone_id
          cidr_block                                     = aws_subnet.restricted-3.cidr_block
          customer_owned_ipv4_pool                       = aws_subnet.restricted-3.customer_owned_ipv4_pool
          enable_dns64                                   = aws_subnet.restricted-3.enable_dns64
          enable_lni_at_device_index                     = aws_subnet.restricted-3.enable_lni_at_device_index
          enable_resource_name_dns_a_record_on_launch    = aws_subnet.restricted-3.enable_resource_name_dns_a_record_on_launch
          enable_resource_name_dns_aaaa_record_on_launch = aws_subnet.restricted-3.enable_resource_name_dns_aaaa_record_on_launch
          id                                             = aws_subnet.restricted-3.id
          ipv6_cidr_block                                = aws_subnet.restricted-3.ipv6_cidr_block
          ipv6_cidr_block_association_id                 = aws_subnet.restricted-3.ipv6_cidr_block_association_id
          ipv6_native                                    = aws_subnet.restricted-3.ipv6_native
          map_customer_owned_ip_on_launch                = aws_subnet.restricted-3.map_customer_owned_ip_on_launch
          map_public_ip_on_launch                        = aws_subnet.restricted-3.map_public_ip_on_launch
          outpost_arn                                    = aws_subnet.restricted-3.outpost_arn
          owner_id                                       = aws_subnet.restricted-3.owner_id
          private_dns_hostname_type_on_launch            = aws_subnet.restricted-3.private_dns_hostname_type_on_launch
          region                                         = aws_subnet.restricted-3.region
          tags                                           = aws_subnet.restricted-3.tags
          tags_all                                       = aws_subnet.restricted-3.tags_all
          vpc_id                                         = aws_subnet.restricted-3.vpc_id
        }
      }
      public = {
        ids = [
          aws_subnet.public-1.id,
          aws_subnet.public-2.id,
          aws_subnet.public-3.id,
        ]
        1 = {
          arn                                            = aws_subnet.public-1.arn
          assign_ipv6_address_on_creation                = aws_subnet.public-1.assign_ipv6_address_on_creation
          availability_zone                              = aws_subnet.public-1.availability_zone
          availability_zone_id                           = aws_subnet.public-1.availability_zone_id
          cidr_block                                     = aws_subnet.public-1.cidr_block
          customer_owned_ipv4_pool                       = aws_subnet.public-1.customer_owned_ipv4_pool
          enable_dns64                                   = aws_subnet.public-1.enable_dns64
          enable_lni_at_device_index                     = aws_subnet.public-1.enable_lni_at_device_index
          enable_resource_name_dns_a_record_on_launch    = aws_subnet.public-1.enable_resource_name_dns_a_record_on_launch
          enable_resource_name_dns_aaaa_record_on_launch = aws_subnet.public-1.enable_resource_name_dns_aaaa_record_on_launch
          id                                             = aws_subnet.public-1.id
          ipv6_cidr_block                                = aws_subnet.public-1.ipv6_cidr_block
          ipv6_cidr_block_association_id                 = aws_subnet.public-1.ipv6_cidr_block_association_id
          ipv6_native                                    = aws_subnet.public-1.ipv6_native
          map_customer_owned_ip_on_launch                = aws_subnet.public-1.map_customer_owned_ip_on_launch
          map_public_ip_on_launch                        = aws_subnet.public-1.map_public_ip_on_launch
          outpost_arn                                    = aws_subnet.public-1.outpost_arn
          owner_id                                       = aws_subnet.public-1.owner_id
          private_dns_hostname_type_on_launch            = aws_subnet.public-1.private_dns_hostname_type_on_launch
          region                                         = aws_subnet.public-1.region
          tags                                           = aws_subnet.public-1.tags
          tags_all                                       = aws_subnet.public-1.tags_all
          vpc_id                                         = aws_subnet.public-1.vpc_id
        }
        2 = {
          arn                                            = aws_subnet.public-2.arn
          assign_ipv6_address_on_creation                = aws_subnet.public-2.assign_ipv6_address_on_creation
          availability_zone                              = aws_subnet.public-2.availability_zone
          availability_zone_id                           = aws_subnet.public-2.availability_zone_id
          cidr_block                                     = aws_subnet.public-2.cidr_block
          customer_owned_ipv4_pool                       = aws_subnet.public-2.customer_owned_ipv4_pool
          enable_dns64                                   = aws_subnet.public-2.enable_dns64
          enable_lni_at_device_index                     = aws_subnet.public-2.enable_lni_at_device_index
          enable_resource_name_dns_a_record_on_launch    = aws_subnet.public-2.enable_resource_name_dns_a_record_on_launch
          enable_resource_name_dns_aaaa_record_on_launch = aws_subnet.public-2.enable_resource_name_dns_aaaa_record_on_launch
          id                                             = aws_subnet.public-2.id
          ipv6_cidr_block                                = aws_subnet.public-2.ipv6_cidr_block
          ipv6_cidr_block_association_id                 = aws_subnet.public-2.ipv6_cidr_block_association_id
          ipv6_native                                    = aws_subnet.public-2.ipv6_native
          map_customer_owned_ip_on_launch                = aws_subnet.public-2.map_customer_owned_ip_on_launch
          map_public_ip_on_launch                        = aws_subnet.public-2.map_public_ip_on_launch
          outpost_arn                                    = aws_subnet.public-2.outpost_arn
          owner_id                                       = aws_subnet.public-2.owner_id
          private_dns_hostname_type_on_launch            = aws_subnet.public-2.private_dns_hostname_type_on_launch
          region                                         = aws_subnet.public-2.region
          tags                                           = aws_subnet.public-2.tags
          tags_all                                       = aws_subnet.public-2.tags_all
          vpc_id                                         = aws_subnet.public-2.vpc_id
        }
        3 = {
          arn                                            = aws_subnet.public-3.arn
          assign_ipv6_address_on_creation                = aws_subnet.public-3.assign_ipv6_address_on_creation
          availability_zone                              = aws_subnet.public-3.availability_zone
          availability_zone_id                           = aws_subnet.public-3.availability_zone_id
          cidr_block                                     = aws_subnet.public-3.cidr_block
          customer_owned_ipv4_pool                       = aws_subnet.public-3.customer_owned_ipv4_pool
          enable_dns64                                   = aws_subnet.public-3.enable_dns64
          enable_lni_at_device_index                     = aws_subnet.public-3.enable_lni_at_device_index
          enable_resource_name_dns_a_record_on_launch    = aws_subnet.public-3.enable_resource_name_dns_a_record_on_launch
          enable_resource_name_dns_aaaa_record_on_launch = aws_subnet.public-3.enable_resource_name_dns_aaaa_record_on_launch
          id                                             = aws_subnet.public-3.id
          ipv6_cidr_block                                = aws_subnet.public-3.ipv6_cidr_block
          ipv6_cidr_block_association_id                 = aws_subnet.public-3.ipv6_cidr_block_association_id
          ipv6_native                                    = aws_subnet.public-3.ipv6_native
          map_customer_owned_ip_on_launch                = aws_subnet.public-3.map_customer_owned_ip_on_launch
          map_public_ip_on_launch                        = aws_subnet.public-3.map_public_ip_on_launch
          outpost_arn                                    = aws_subnet.public-3.outpost_arn
          owner_id                                       = aws_subnet.public-3.owner_id
          private_dns_hostname_type_on_launch            = aws_subnet.public-3.private_dns_hostname_type_on_launch
          region                                         = aws_subnet.public-3.region
          tags                                           = aws_subnet.public-3.tags
          tags_all                                       = aws_subnet.public-3.tags_all
          vpc_id                                         = aws_subnet.public-3.vpc_id
        }
      }
    }

    vpc = {
      arn                                  = aws_vpc.this.arn
      assign_generated_ipv6_cidr_block     = aws_vpc.this.assign_generated_ipv6_cidr_block
      cidr_block                           = aws_vpc.this.cidr_block
      default_network_acl_id               = aws_vpc.this.default_network_acl_id
      default_route_table_id               = aws_vpc.this.default_route_table_id
      default_security_group_id            = aws_vpc.this.default_security_group_id
      dhcp_options_id                      = aws_vpc.this.dhcp_options_id
      enable_dns_hostnames                 = aws_vpc.this.enable_dns_hostnames
      enable_dns_support                   = aws_vpc.this.enable_dns_support
      enable_network_address_usage_metrics = aws_vpc.this.enable_network_address_usage_metrics
      id                                   = aws_vpc.this.id
      instance_tenancy                     = aws_vpc.this.instance_tenancy
      ipv4_ipam_pool_id                    = aws_vpc.this.ipv4_ipam_pool_id
      ipv4_netmask_length                  = aws_vpc.this.ipv4_netmask_length
      ipv6_association_id                  = aws_vpc.this.ipv6_association_id
      ipv6_cidr_block                      = aws_vpc.this.ipv6_cidr_block
      ipv6_cidr_block_network_border_group = aws_vpc.this.ipv6_cidr_block_network_border_group
      ipv6_ipam_pool_id                    = aws_vpc.this.ipv6_ipam_pool_id
      ipv6_netmask_length                  = aws_vpc.this.ipv6_netmask_length
      main_route_table_id                  = aws_vpc.this.main_route_table_id
      owner_id                             = aws_vpc.this.owner_id
      region                               = aws_vpc.this.region
      tags                                 = aws_vpc.this.tags
      tags_all                             = aws_vpc.this.tags_all
      name                                 = local.vpc.name
      abbr                                 = local.vpc.abbr
      machine                              = local.vpc.machine
    }

    vpc_endpoint = {
      dynamodb = {
        arn                        = aws_vpc_endpoint.dynamodb.arn
        auto_accept                = aws_vpc_endpoint.dynamodb.auto_accept
        cidr_blocks                = aws_vpc_endpoint.dynamodb.cidr_blocks
        dns_entry                  = aws_vpc_endpoint.dynamodb.dns_entry
        dns_options                = aws_vpc_endpoint.dynamodb.dns_options
        id                         = aws_vpc_endpoint.dynamodb.id
        ip_address_type            = aws_vpc_endpoint.dynamodb.ip_address_type
        network_interface_ids      = aws_vpc_endpoint.dynamodb.network_interface_ids
        owner_id                   = aws_vpc_endpoint.dynamodb.owner_id
        policy                     = aws_vpc_endpoint.dynamodb.policy
        prefix_list_id             = aws_vpc_endpoint.dynamodb.prefix_list_id
        private_dns_enabled        = aws_vpc_endpoint.dynamodb.private_dns_enabled
        region                     = aws_vpc_endpoint.dynamodb.region
        requester_managed          = aws_vpc_endpoint.dynamodb.requester_managed
        resource_configuration_arn = aws_vpc_endpoint.dynamodb.resource_configuration_arn
        route_table_ids            = aws_vpc_endpoint.dynamodb.route_table_ids
        security_group_ids         = aws_vpc_endpoint.dynamodb.security_group_ids
        service_name               = aws_vpc_endpoint.dynamodb.service_name
        service_network_arn        = aws_vpc_endpoint.dynamodb.service_network_arn
        service_region             = aws_vpc_endpoint.dynamodb.service_region
        state                      = aws_vpc_endpoint.dynamodb.state
        subnet_configuration       = aws_vpc_endpoint.dynamodb.subnet_configuration
        subnet_ids                 = aws_vpc_endpoint.dynamodb.subnet_ids
        tags                       = aws_vpc_endpoint.dynamodb.tags
        tags_all                   = aws_vpc_endpoint.dynamodb.tags_all
        vpc_endpoint_type          = aws_vpc_endpoint.dynamodb.vpc_endpoint_type
        vpc_id                     = aws_vpc_endpoint.dynamodb.vpc_id
      }
      s3 = {
        arn                        = aws_vpc_endpoint.s3.arn
        auto_accept                = aws_vpc_endpoint.s3.auto_accept
        cidr_blocks                = aws_vpc_endpoint.s3.cidr_blocks
        dns_entry                  = aws_vpc_endpoint.s3.dns_entry
        dns_options                = aws_vpc_endpoint.s3.dns_options
        id                         = aws_vpc_endpoint.s3.id
        ip_address_type            = aws_vpc_endpoint.s3.ip_address_type
        network_interface_ids      = aws_vpc_endpoint.s3.network_interface_ids
        owner_id                   = aws_vpc_endpoint.s3.owner_id
        policy                     = aws_vpc_endpoint.s3.policy
        prefix_list_id             = aws_vpc_endpoint.s3.prefix_list_id
        private_dns_enabled        = aws_vpc_endpoint.s3.private_dns_enabled
        region                     = aws_vpc_endpoint.s3.region
        requester_managed          = aws_vpc_endpoint.s3.requester_managed
        resource_configuration_arn = aws_vpc_endpoint.s3.resource_configuration_arn
        route_table_ids            = aws_vpc_endpoint.s3.route_table_ids
        security_group_ids         = aws_vpc_endpoint.s3.security_group_ids
        service_name               = aws_vpc_endpoint.s3.service_name
        service_network_arn        = aws_vpc_endpoint.s3.service_network_arn
        service_region             = aws_vpc_endpoint.s3.service_region
        state                      = aws_vpc_endpoint.s3.state
        subnet_configuration       = aws_vpc_endpoint.s3.subnet_configuration
        subnet_ids                 = aws_vpc_endpoint.s3.subnet_ids
        tags                       = aws_vpc_endpoint.s3.tags
        tags_all                   = aws_vpc_endpoint.s3.tags_all
        vpc_endpoint_type          = aws_vpc_endpoint.s3.vpc_endpoint_type
        vpc_id                     = aws_vpc_endpoint.s3.vpc_id
      }
    }
  }
}
