# Copyright 2026 Automate the Cloud Inc.
# SPDX-License-Identifier: Apache-2.0

# Whether flow_log is null is known at plan time even when the bucket is created in the
# same run, so the count never depends on a value known only after apply.
resource "aws_flow_log" "s3" {
  count                    = var.flow_log != null ? 1 : 0
  region                   = var.region
  vpc_id                   = aws_vpc.this.id
  log_destination_type     = "s3"
  log_destination          = var.flow_log.s3_bucket_arn
  traffic_type             = var.flow_log.traffic_type
  log_format               = var.flow_log.log_format
  max_aggregation_interval = var.flow_log.max_aggregation_interval

  destination_options {
    file_format                = var.flow_log.file_format
    hive_compatible_partitions = var.flow_log.hive_compatible_partitions
    per_hour_partition         = var.flow_log.per_hour_partition
  }

  tags = merge(
    local.tags,
    {
      "Name" = "${local.vpc.abbr}-${local.aws.region.abbr}",
    }
  )
}
