# Copyright 2025 Automate the Cloud Inc.
# SPDX-License-Identifier: Apache-2.0

# A VPC with only the required inputs: 172.16.0.0/16, nine subnets in three tiers
# across three Availability Zones, and network ACLs that deny all traffic until you
# add rules.

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

# The first three Availability Zones in the provider's Region.
data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "../../"

  details = {
    scope       = "Example"
    purpose     = "Basic VPC"
    environment = "Development"
  }

  vpc_name                   = "Example"
  network_availability_zones = slice(data.aws_availability_zones.available.names, 0, 3)
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.metadata.vpc.id
}

output "subnet_ids" {
  description = "Subnet IDs by tier, in Availability Zone order"
  value = {
    private    = module.vpc.metadata.subnet.private.ids
    restricted = module.vpc.metadata.subnet.restricted.ids
    public     = module.vpc.metadata.subnet.public.ids
  }
}
