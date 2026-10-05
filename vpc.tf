# Copyright 2025 Automate the Cloud Inc.
# SPDX-License-Identifier: Apache-2.0

resource "aws_vpc" "this" {
  region               = var.region
  cidr_block           = local.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  assign_generated_ipv6_cidr_block = var.enable_ipv6

  tags = merge(
    local.tags,
    {
      "Name" = "${local.vpc.abbr}-${local.aws.region.abbr}",
    }
  )
}
