# Copyright 2026 Automate the Cloud Inc.
# SPDX-License-Identifier: Apache-2.0

variable "details" {
  description = <<-EOT
    Names and tags shared by every resource in the module. `scope`, `purpose` and `environment` become the `Scope`, `Purpose` and `Environment` tags, and are converted to abbreviations that other modules can use in resource names (see the `metadata` output). [The `details` input](https://github.com/AutomateTheCloud/terraform-aws-vpc#the-details-input) explains why it is required.

    - `scope` - (Required) What the resource belongs to, such as an organization or project: `Automate the Cloud`.
    - `purpose` - (Required) What the resource is for: `Shared Network`.
    - `environment` - (Required) The environment: `Production`.
    - `scope_abbr`, `purpose_abbr`, `environment_abbr` - (Optional) Abbreviations to use instead of the generated ones, which are lowercase with words joined by underscores (`Shared Network` becomes `shared_network`).
    - `additional_tags` - (Optional) More tags for every resource, such as `{ CostCenter = "1234" }`.
  EOT
  type = object({
    scope            = string
    scope_abbr       = optional(string)
    purpose          = string
    purpose_abbr     = optional(string)
    environment      = string
    environment_abbr = optional(string)
    additional_tags  = optional(map(string), {})
  })
  nullable = false

  validation {
    condition     = trimspace(var.details.scope) != ""
    error_message = "Scope not specified."
  }

  validation {
    condition     = trimspace(var.details.purpose) != ""
    error_message = "Purpose not specified."
  }

  validation {
    condition     = trimspace(var.details.environment) != ""
    error_message = "Environment not specified."
  }
}

variable "enable_igw_on_restricted_subnets" {
  description = <<-EOT
    Add a default route from the restricted subnets to the internet: `0.0.0.0/0` through the internet gateway, and `::/0` through the egress-only internet gateway when `enable_ipv6` is `true`. Defaults to `false`, so restricted subnets have no route out of the VPC.

    Restricted subnets never assign public IPv4 addresses, so an instance there reaches the internet over IPv4 only if it has an Elastic IP address.
  EOT
  type        = bool
  default     = false
  nullable    = false
}

variable "enable_ipv6" {
  description = <<-EOT
    Give the VPC an Amazon-provided IPv6 `/56` block and each subnet a `/64` from it, and assign IPv6 addresses to new network interfaces. Public subnets route `::/0` through the internet gateway; private subnets route it through an egress-only internet gateway, which allows connections out but not in. Defaults to `false`.

    Turning it on later updates the VPC and subnets in place.
  EOT
  type        = bool
  default     = false
  nullable    = false
}

variable "enable_kms_key_data" {
  description = <<-EOT
    Create a customer managed KMS key, with the alias `alias/data-<vpc abbr>`, for encrypting data that workloads in this VPC store. Nothing in this module uses it. The key policy lets the account's IAM policies grant access, and lets CloudWatch Logs use the key for log groups in this account and Region. Key rotation is on, and a deleted key can be recovered for 10 days. Defaults to `false`.

    A KMS key is billed monthly while it exists, including while it is scheduled for deletion.
  EOT
  type        = bool
  default     = false
  nullable    = false
}

variable "flow_log" {
  description = <<-EOT
    Send VPC flow logs, a record of the IP traffic in the VPC, to an S3 bucket. Defaults to `null`: no flow logs. The bucket must already allow log delivery; [the complete example](https://github.com/AutomateTheCloud/terraform-aws-vpc/tree/main/examples/complete) shows a bucket policy that does.

    - `s3_bucket_arn` - (Required) ARN of the bucket, optionally followed by a folder: `arn:aws:s3:::my-flow-logs` or `arn:aws:s3:::my-flow-logs/vpc`.
    - `traffic_type` - (Optional) `ALL`, `ACCEPT` (allowed traffic only) or `REJECT` (rejected traffic only). Defaults to `ALL`.
    - `log_format` - (Optional) The fields to record, in flow log format syntax. Defaults to every field up to version 5 of the format, in alphabetical order.
    - `max_aggregation_interval` - (Optional) The longest time, in seconds, over which traffic is collected into one record: `60` or `600`. Defaults to `600`.
    - `file_format` - (Optional) `plain-text` or `parquet`. Defaults to `plain-text`.
    - `hive_compatible_partitions` - (Optional) Use Hive-compatible folder names, such as `year=2025/`, for query tools like Amazon Athena. Defaults to `false`.
    - `per_hour_partition` - (Optional) Write one folder per hour instead of one per day. Defaults to `false`.
  EOT
  type = object({
    s3_bucket_arn              = string
    traffic_type               = optional(string, "ALL")
    log_format                 = optional(string, "$${account-id} $${action} $${az-id} $${bytes} $${dstaddr} $${dstport} $${end} $${flow-direction} $${instance-id} $${interface-id} $${log-status} $${packets} $${pkt-dst-aws-service} $${pkt-dstaddr} $${pkt-src-aws-service} $${pkt-srcaddr} $${protocol} $${region} $${srcaddr} $${srcport} $${start} $${sublocation-id} $${sublocation-type} $${subnet-id} $${tcp-flags} $${traffic-path} $${type} $${version} $${vpc-id}")
    max_aggregation_interval   = optional(number, 600)
    file_format                = optional(string, "plain-text")
    hive_compatible_partitions = optional(bool, false)
    per_hour_partition         = optional(bool, false)
  })
  default = null

  validation {
    condition     = var.flow_log == null ? true : can(regex("^arn:[a-z-]+:s3:::[a-z0-9][a-z0-9.-]{1,61}[a-z0-9](/.*)?$", var.flow_log.s3_bucket_arn))
    error_message = "flow_log.s3_bucket_arn must be an S3 bucket ARN, such as arn:aws:s3:::my-flow-logs, optionally followed by /folder."
  }

  validation {
    condition     = var.flow_log == null ? true : contains(["ALL", "ACCEPT", "REJECT"], var.flow_log.traffic_type)
    error_message = "flow_log.traffic_type must be ALL, ACCEPT or REJECT."
  }

  validation {
    condition     = var.flow_log == null ? true : contains([60, 600], var.flow_log.max_aggregation_interval)
    error_message = "flow_log.max_aggregation_interval must be 60 or 600."
  }

  validation {
    condition     = var.flow_log == null ? true : contains(["plain-text", "parquet"], var.flow_log.file_format)
    error_message = "flow_log.file_format must be plain-text or parquet."
  }
}

variable "network_acl_egress_use_default_all" {
  description = <<-EOT
    Add a rule to each subnet tier's network ACL that allows all outbound traffic to anywhere (`0.0.0.0/0`, and `::/0` when `enable_ipv6` is `true`). Defaults to `false`: the network ACLs have no rules, so they deny all traffic until you add your own rules (see [the network ACL rules example](https://github.com/AutomateTheCloud/terraform-aws-vpc/tree/main/examples/network-acl-rules)).
  EOT
  type        = bool
  default     = false
  nullable    = false
}

variable "network_acl_ingress_use_default_all" {
  description = <<-EOT
    Add a rule to each subnet tier's network ACL that allows all inbound traffic from anywhere (`0.0.0.0/0`, and `::/0` when `enable_ipv6` is `true`). Defaults to `false`: the network ACLs have no rules, so they deny all traffic until you add your own rules. With this on, security groups are the only traffic filter.
  EOT
  type        = bool
  default     = false
  nullable    = false
}

variable "network_availability_zones" {
  description = <<-EOT
    The three Availability Zones to place subnets in, one subnet of each tier per zone, such as `["us-east-1a", "us-east-1b", "us-east-1c"]`. They must be in the module's Region and all different.
  EOT
  type        = list(string)
  nullable    = false

  validation {
    condition     = length(var.network_availability_zones) == 3
    error_message = "network_availability_zones must list exactly 3 Availability Zones."
  }

  validation {
    condition     = length(distinct(var.network_availability_zones)) == length(var.network_availability_zones)
    error_message = "network_availability_zones must all be different."
  }
}

variable "network_ip_netmask" {
  description = <<-EOT
    The prefix length of the VPC's IPv4 block, from `16` (65,536 addresses) to `24` (256 addresses). Defaults to `16`. The smallest subnets are 4 bits longer, and AWS does not allow subnets smaller than `/28`.
  EOT
  type        = number
  default     = 16
  nullable    = false

  validation {
    condition     = floor(var.network_ip_netmask) == var.network_ip_netmask && var.network_ip_netmask >= 16 && var.network_ip_netmask <= 24
    error_message = "network_ip_netmask must be a whole number from 16 to 24."
  }
}

variable "network_ip_network" {
  description = <<-EOT
    The first address of the VPC's IPv4 block, such as `10.20.0.0`. Together with `network_ip_netmask` it forms the block (`10.20.0.0/16`), so it must be the first address of a block of that size. Defaults to `172.16.0.0`. Use a private range (`10.0.0.0/8`, `172.16.0.0/12` or `192.168.0.0/16`) that does not overlap any network you will connect this VPC to.
  EOT
  type        = string
  default     = "172.16.0.0"
  nullable    = false

  validation {
    condition     = can(regex("^((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\\.){3}(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])$", var.network_ip_network))
    error_message = "network_ip_network must be an IPv4 address, such as 10.20.0.0."
  }

  validation {
    condition     = try(cidrhost("${var.network_ip_network}/${var.network_ip_netmask}", 0) == var.network_ip_network, true)
    error_message = "network_ip_network must be the first address of its block: with network_ip_netmask = ${var.network_ip_netmask}, use ${try(cidrhost("${var.network_ip_network}/${var.network_ip_netmask}", 0), "an aligned address")}."
  }
}

variable "region" {
  description = <<-EOT
    The AWS Region to create the VPC and everything in it in, such as `us-west-2`. Defaults to the Region of the AWS provider passed to the module.
  EOT
  type        = string
  default     = null
}

variable "vpc_endpoint_route_tables" {
  description = <<-EOT
    Which subnet tiers' route tables the S3 and DynamoDB gateway endpoints are added to: any of `private`, `restricted` and `public`. Defaults to all three. Traffic to S3 and DynamoDB in the same Region from a listed tier stays on the AWS network, at no charge. An empty list leaves the endpoints on no route tables.
  EOT
  type        = list(string)
  default     = ["private", "restricted", "public"]
  nullable    = false

  validation {
    condition     = alltrue([for rt in var.vpc_endpoint_route_tables : contains(["private", "restricted", "public"], rt)])
    error_message = "vpc_endpoint_route_tables may contain only private, restricted and public."
  }
}

variable "vpc_name" {
  description = <<-EOT
    The name of the VPC, such as `Shared Services`. Resource names are built from it: `Name` tags and DB subnet group names use the lowercase form with words joined by underscores (`shared_services`), and ElastiCache subnet group names use letters and numbers only (`sharedservices`).
  EOT
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("[0-9A-Za-z]", var.vpc_name))
    error_message = "vpc_name must contain at least one letter or number."
  }
}
