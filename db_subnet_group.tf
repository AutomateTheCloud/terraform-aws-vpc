# Copyright 2025 Automate the Cloud Inc.
# SPDX-License-Identifier: Apache-2.0

#------------------------------------------------------------------------------
# DB Subnet Group - Private
resource "aws_db_subnet_group" "private" {
  region      = var.region
  name        = "${local.vpc.abbr}-db-private-${local.aws.region.abbr}"
  description = "${local.vpc.name} - DB Private - ${local.aws.region.name}"
  subnet_ids = [
    aws_subnet.private-1.id,
    aws_subnet.private-2.id,
    aws_subnet.private-3.id
  ]
  tags = merge(
    local.tags,
    {
      "Name" = "${local.vpc.abbr}-db-private-${local.aws.region.abbr}",
    }
  )
}

#------------------------------------------------------------------------------
# DB Subnet Group - Restricted
resource "aws_db_subnet_group" "restricted" {
  region      = var.region
  name        = "${local.vpc.abbr}-db-restricted-${local.aws.region.abbr}"
  description = "${local.vpc.name} - DB Restricted - ${local.aws.region.name}"
  subnet_ids = [
    aws_subnet.restricted-1.id,
    aws_subnet.restricted-2.id,
    aws_subnet.restricted-3.id
  ]
  tags = merge(
    local.tags,
    {
      "Name" = "${local.vpc.abbr}-db-restricted-${local.aws.region.abbr}",
    }
  )
}

#------------------------------------------------------------------------------
# DB Subnet Group - Public
resource "aws_db_subnet_group" "public" {
  region      = var.region
  name        = "${local.vpc.abbr}-db-public-${local.aws.region.abbr}"
  description = "${local.vpc.name} - DB Public - ${local.aws.region.name}"
  subnet_ids = [
    aws_subnet.public-1.id,
    aws_subnet.public-2.id,
    aws_subnet.public-3.id
  ]
  tags = merge(
    local.tags,
    {
      "Name" = "${local.vpc.abbr}-db-public-${local.aws.region.abbr}",
    }
  )
}
