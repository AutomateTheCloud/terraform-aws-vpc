# Copyright 2026 Automate the Cloud Inc.
# SPDX-License-Identifier: Apache-2.0

resource "aws_default_route_table" "this" {
  region                 = var.region
  default_route_table_id = aws_vpc.this.default_route_table_id
  tags = merge(
    local.tags,
    {
      "Name"   = "${local.vpc.abbr}-default-${local.aws.region.abbr}",
      "Active" = "false",
      "Note"   = "DO NOT USE OR MODIFY",
    }
  )
}
