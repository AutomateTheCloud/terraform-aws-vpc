# Copyright 2025 Automate the Cloud Inc.
# SPDX-License-Identifier: Apache-2.0

#------------------------------------------------------------------------------
# ElastiCache Subnet Group - Private
resource "aws_elasticache_subnet_group" "private" {
  region      = var.region
  name        = "${local.vpc.machine}-elasticache-private-${local.aws.region.abbr}"
  description = "${local.vpc.name} - ElastiCache Private - ${local.aws.region.name}"
  subnet_ids = [
    aws_subnet.private-1.id,
    aws_subnet.private-2.id,
    aws_subnet.private-3.id
  ]
  tags = merge(
    local.tags,
    {
      "Name" = "${local.vpc.machine}-elasticache-private-${local.aws.region.abbr}",
    }
  )
}

#------------------------------------------------------------------------------
# ElastiCache Subnet Group - Restricted
resource "aws_elasticache_subnet_group" "restricted" {
  region      = var.region
  name        = "${local.vpc.machine}-elasticache-restricted-${local.aws.region.abbr}"
  description = "${local.vpc.name} - ElastiCache Restricted - ${local.aws.region.name}"
  subnet_ids = [
    aws_subnet.restricted-1.id,
    aws_subnet.restricted-2.id,
    aws_subnet.restricted-3.id
  ]
  tags = merge(
    local.tags,
    {
      "Name" = "${local.vpc.machine}-elasticache-restricted-${local.aws.region.abbr}",
    }
  )
}

#------------------------------------------------------------------------------
# ElastiCache Subnet Group - Public
resource "aws_elasticache_subnet_group" "public" {
  region      = var.region
  name        = "${local.vpc.machine}-elasticache-public-${local.aws.region.abbr}"
  description = "${local.vpc.name} - ElastiCache Public - ${local.aws.region.name}"
  subnet_ids = [
    aws_subnet.public-1.id,
    aws_subnet.public-2.id,
    aws_subnet.public-3.id
  ]
  tags = merge(
    local.tags,
    {
      "Name" = "${local.vpc.machine}-elasticache-public-${local.aws.region.abbr}",
    }
  )
}
