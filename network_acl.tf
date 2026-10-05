# Copyright 2025 Automate the Cloud Inc.
# SPDX-License-Identifier: Apache-2.0

resource "aws_network_acl" "private" {
  region = var.region
  vpc_id = aws_vpc.this.id
  subnet_ids = [
    aws_subnet.private-1.id,
    aws_subnet.private-2.id,
    aws_subnet.private-3.id
  ]
  tags = merge(
    local.tags,
    {
      "Name"    = "${local.vpc.abbr}-private-${local.aws.region.abbr}",
      "Network" = "private",
    }
  )
}

resource "aws_network_acl" "restricted" {
  region = var.region
  vpc_id = aws_vpc.this.id
  subnet_ids = [
    aws_subnet.restricted-1.id,
    aws_subnet.restricted-2.id,
    aws_subnet.restricted-3.id
  ]
  tags = merge(
    local.tags,
    {
      "Name"    = "${local.vpc.abbr}-restricted-${local.aws.region.abbr}",
      "Network" = "restricted",
    }
  )
}

resource "aws_network_acl" "public" {
  region = var.region
  vpc_id = aws_vpc.this.id
  subnet_ids = [
    aws_subnet.public-1.id,
    aws_subnet.public-2.id,
    aws_subnet.public-3.id
  ]
  tags = merge(
    local.tags,
    {
      "Name"    = "${local.vpc.abbr}-public-${local.aws.region.abbr}",
      "Network" = "public",
    }
  )
}
