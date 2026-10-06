# Copyright 2026 Automate the Cloud Inc.
# SPDX-License-Identifier: Apache-2.0

resource "aws_internet_gateway" "this" {
  region = var.region
  vpc_id = aws_vpc.this.id
  tags = merge(
    local.tags,
    {
      "Name" = "${local.vpc.abbr}-${local.aws.region.abbr}",
    }
  )
}
