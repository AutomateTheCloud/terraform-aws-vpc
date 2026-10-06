# Copyright 2026 Automate the Cloud Inc.
# SPDX-License-Identifier: Apache-2.0

resource "aws_default_network_acl" "this" {
  region                 = var.region
  default_network_acl_id = aws_vpc.this.default_network_acl_id
  tags = merge(
    local.tags,
    {
      "Name" = "${local.vpc.abbr}-default-${local.aws.region.abbr}",
      "Note" = "DO NOT USE OR MODIFY",
    }
  )
  depends_on = [
    aws_network_acl.private,
    aws_network_acl.restricted,
    aws_network_acl.public
  ]
}
