# Copyright 2026 Automate the Cloud Inc.
# SPDX-License-Identifier: Apache-2.0

# The module's network ACLs start with no rules, so they deny all traffic. This
# example adds the rules most VPCs need:
#
# - Every tier: TCP and UDP to and from addresses inside the VPC.
# - Public tier: HTTPS in from the internet, and the replies out. Network ACLs are
#   stateless, so replies, which go to the client's ephemeral port (1024-65535),
#   need their own rule.
#
# Security groups still decide which instances accept which traffic. Network ACLs
# are a second, subnet-wide layer.

terraform {
  required_version = ">= 1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "../../"

  details = {
    scope       = "Example"
    purpose     = "Network ACL Rules"
    environment = "Development"
  }

  vpc_name                   = "Example"
  network_availability_zones = slice(data.aws_availability_zones.available.names, 0, 3)
  network_ip_network         = "10.30.0.0"
  network_ip_netmask         = 16
}

locals {
  vpc_cidr = module.vpc.metadata.vpc.cidr_block
  network_acl_ids = {
    private    = module.vpc.metadata.network_acl.private.id
    restricted = module.vpc.metadata.network_acl.restricted.id
    public     = module.vpc.metadata.network_acl.public.id
  }

  # Inside the VPC: one rule per protocol, in each direction, on every tier.
  vpc_rules = {
    for pair in setproduct(keys(local.network_acl_ids), ["tcp", "udp"], [false, true]) :
    "${pair[0]}-${pair[1]}-${pair[2] ? "out" : "in"}" => {
      network_acl_id = local.network_acl_ids[pair[0]]
      protocol       = pair[1]
      egress         = pair[2]
      rule_number    = pair[1] == "tcp" ? 100 : 110
    }
  }
}

resource "aws_network_acl_rule" "vpc" {
  for_each = local.vpc_rules

  network_acl_id = each.value.network_acl_id
  rule_number    = each.value.rule_number
  egress         = each.value.egress
  protocol       = each.value.protocol
  rule_action    = "allow"
  cidr_block     = local.vpc_cidr
  from_port      = 0
  to_port        = 65535
}

# Public tier: HTTPS in from anywhere.
resource "aws_network_acl_rule" "public_https_in" {
  network_acl_id = local.network_acl_ids.public
  rule_number    = 200
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

# Public tier: replies to those HTTPS connections.
resource "aws_network_acl_rule" "public_replies_out" {
  network_acl_id = local.network_acl_ids.public
  rule_number    = 200
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

output "network_acl_ids" {
  description = "Network ACL IDs by tier"
  value       = local.network_acl_ids
}
