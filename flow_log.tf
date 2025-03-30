resource "aws_flow_log" "s3" {
  count                = try(var.flow_log.s3.enable, false) ? 1 : 0
  log_destination      = try(var.flow_log.s3.s3_bucket_arn, null)
  log_destination_type = "s3"
  traffic_type         = try(var.flow_log.s3.traffic_type, "ALL")

  log_format               = try(var.flow_log.s3.log_format, "$${account-id} $${action} $${az-id} $${bytes} $${dstaddr} $${dstport} $${end} $${flow-direction} $${instance-id} $${interface-id} $${log-status} $${packets} $${pkt-dst-aws-service} $${pkt-dstaddr} $${pkt-src-aws-service} $${pkt-srcaddr} $${protocol} $${region} $${srcaddr} $${srcport} $${start} $${sublocation-id} $${sublocation-type} $${subnet-id} $${tcp-flags} $${traffic-path} $${type} $${version} $${vpc-id}")
  max_aggregation_interval = try(var.flow_log.s3.max_aggregation_interval, 600)
  destination_options {
    file_format                = try(var.flow_log.s3.destination_options.file_format, "plain-text")
    hive_compatible_partitions = try(var.flow_log.s3.destination_options.hive_compatible_partitions, false)
    per_hour_partition         = try(var.flow_log.s3.destination_options.per_hour_partition, false)
  }

  vpc_id   = aws_vpc.this.id
  tags     = local.tags
  provider = aws.this
}
