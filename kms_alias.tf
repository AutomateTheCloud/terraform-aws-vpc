# Copyright 2026 Automate the Cloud Inc.
# SPDX-License-Identifier: Apache-2.0

resource "aws_kms_alias" "this" {
  count         = var.enable_kms_key_data ? 1 : 0
  region        = var.region
  name          = "alias/data-${local.vpc.abbr}"
  target_key_id = aws_kms_key.this[0].key_id
}
