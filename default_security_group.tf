# Copyright 2025 Automate the Cloud Inc.
# SPDX-License-Identifier: Apache-2.0

resource "aws_default_security_group" "this" {
  region = var.region
  vpc_id = aws_vpc.this.id

  # Explicitly define no ingress or egress rules to lock down the default security group
  # This prevents accidental use and follows AWS security best practices
  ingress = []
  egress  = []

  tags = merge(
    local.tags,
    {
      "Name" = "${local.vpc.abbr}-default-${local.aws.region.abbr}",
      "Note" = "DO NOT USE OR MODIFY",
    }
  )
}
