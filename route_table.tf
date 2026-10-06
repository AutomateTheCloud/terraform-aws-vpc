# Copyright 2026 Automate the Cloud Inc.
# SPDX-License-Identifier: Apache-2.0

resource "aws_route_table" "private-1" {
  region = var.region
  vpc_id = aws_vpc.this.id
  tags = merge(
    local.tags,
    {
      "Name"    = "${local.vpc.abbr}-private-1-${local.aws.region.abbr}",
      "Network" = "private",
    }
  )
}

resource "aws_route_table" "private-2" {
  region = var.region
  vpc_id = aws_vpc.this.id
  tags = merge(
    local.tags,
    {
      "Name"    = "${local.vpc.abbr}-private-2-${local.aws.region.abbr}",
      "Network" = "private",
    }
  )
}

resource "aws_route_table" "private-3" {
  region = var.region
  vpc_id = aws_vpc.this.id
  tags = merge(
    local.tags,
    {
      "Name"    = "${local.vpc.abbr}-private-3-${local.aws.region.abbr}",
      "Network" = "private",
    }
  )
}

resource "aws_route_table" "restricted-1" {
  region = var.region
  vpc_id = aws_vpc.this.id
  tags = merge(
    local.tags,
    {
      "Name"    = "${local.vpc.abbr}-restricted-1-${local.aws.region.abbr}",
      "Network" = "restricted",
    }
  )
}

resource "aws_route_table" "restricted-2" {
  region = var.region
  vpc_id = aws_vpc.this.id
  tags = merge(
    local.tags,
    {
      "Name"    = "${local.vpc.abbr}-restricted-2-${local.aws.region.abbr}",
      "Network" = "restricted",
    }
  )
}

resource "aws_route_table" "restricted-3" {
  region = var.region
  vpc_id = aws_vpc.this.id
  tags = merge(
    local.tags,
    {
      "Name"    = "${local.vpc.abbr}-restricted-3-${local.aws.region.abbr}",
      "Network" = "restricted",
    }
  )
}

resource "aws_route_table" "public-1" {
  region = var.region
  vpc_id = aws_vpc.this.id
  tags = merge(
    local.tags,
    {
      "Name"    = "${local.vpc.abbr}-public-1-${local.aws.region.abbr}",
      "Network" = "public",
    }
  )
}

resource "aws_route_table" "public-2" {
  region = var.region
  vpc_id = aws_vpc.this.id
  tags = merge(
    local.tags,
    {
      "Name"    = "${local.vpc.abbr}-public-2-${local.aws.region.abbr}",
      "Network" = "public",
    }
  )
}

resource "aws_route_table" "public-3" {
  region = var.region
  vpc_id = aws_vpc.this.id
  tags = merge(
    local.tags,
    {
      "Name"    = "${local.vpc.abbr}-public-3-${local.aws.region.abbr}",
      "Network" = "public",
    }
  )
}
