# Copyright 2026 Automate the Cloud Inc.
# SPDX-License-Identifier: Apache-2.0

# One test per bug found in the review before 1.0.0.
mock_provider "aws" {
  mock_data "aws_region" {
    defaults = { region = "us-east-1", description = "US East (N. Virginia)" }
  }
  mock_data "aws_caller_identity" {
    defaults = { account_id = "111111111111" }
  }
  mock_data "aws_partition" {
    defaults = { partition = "aws" }
  }
  mock_data "aws_service_principal" {
    defaults = { name = "logs.amazonaws.com" }
  }
  mock_data "aws_iam_policy_document" {
    defaults = { json = "{\"Version\":\"2012-10-17\",\"Statement\":[]}" }
  }
  mock_resource "aws_vpc" {
    defaults = { ipv6_cidr_block = "2600:1f18:1234:5600::/56" }
  }
}

variables {
  details                    = { scope = "Test", purpose = "Regressions", environment = "test" }
  vpc_name                   = "Test"
  network_availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

# Netmasks above 24 used to pass validation, giving subnets smaller than the /28 AWS allows.
run "netmask_above_24_rejected" {
  command = plan
  variables { network_ip_netmask = 25 }
  expect_failures = [var.network_ip_netmask]
}

# IPv6 routes to the egress-only internet gateway used gateway_id.
run "egress_only_gateway_route_argument" {
  command = apply
  variables {
    enable_ipv6                      = true
    enable_igw_on_restricted_subnets = true
  }
  assert {
    condition = alltrue([
      aws_route.internet_gateway-private-1-ipv6[0].egress_only_gateway_id == aws_egress_only_internet_gateway.this[0].id,
      aws_route.internet_gateway-private-3-ipv6[0].egress_only_gateway_id == aws_egress_only_internet_gateway.this[0].id,
      aws_route.internet_gateway-restricted-2-ipv6[0].egress_only_gateway_id == aws_egress_only_internet_gateway.this[0].id,
    ])
    error_message = "IPv6 routes must use egress_only_gateway_id for the egress-only internet gateway."
  }
  assert {
    condition     = aws_route.internet_gateway-public-1-ipv6[0].gateway_id == aws_internet_gateway.this.id
    error_message = "Public IPv6 routes must use the internet gateway."
  }
  assert {
    condition     = aws_subnet.private-2.ipv6_cidr_block == "2600:1f18:1234:5601::/64" && aws_subnet.public-3.ipv6_cidr_block == "2600:1f18:1234:560e::/64"
    error_message = "Unexpected subnet IPv6 blocks."
  }
}

# flow_log was typed `any` and read with try(), so a misspelled attribute was ignored and
# a flow log with no destination planned. It is now a typed object.
run "flow_log_typed" {
  command = plan
  variables {
    flow_log = { s3_bucket_arn = "arn:aws:s3:::my-flow-logs/vpc", traffic_type = "REJECT" }
  }
  assert {
    condition     = aws_flow_log.s3[0].log_destination == "arn:aws:s3:::my-flow-logs/vpc" && aws_flow_log.s3[0].traffic_type == "REJECT"
    error_message = "Flow log settings did not reach the flow log."
  }
  assert {
    condition     = aws_flow_log.s3[0].max_aggregation_interval == 600 && one(aws_flow_log.s3[0].destination_options).file_format == "plain-text"
    error_message = "Unexpected flow log defaults."
  }
}

# ElastiCache subnet groups were the only resources without tags.
run "elasticache_subnet_groups_tagged" {
  command = plan
  assert {
    condition = alltrue([
      aws_elasticache_subnet_group.private.tags["Scope"] == "Test",
      aws_elasticache_subnet_group.restricted.tags["Name"] == "test-elasticache-restricted-use1",
      aws_elasticache_subnet_group.public.tags["Environment"] == "test",
    ])
    error_message = "ElastiCache subnet groups must be tagged."
  }
}

# The same Availability Zone three times passed validation.
run "duplicate_availability_zones_rejected" {
  command = plan
  variables { network_availability_zones = ["us-east-1a", "us-east-1a", "us-east-1b"] }
  expect_failures = [var.network_availability_zones]
}

# The KMS key policy hard-coded arn:aws:, which is wrong in GovCloud and China.
run "kms_policy_uses_the_partition" {
  command = plan
  variables { enable_kms_key_data = true }
  override_data {
    target = data.aws_region.this
    values = { region = "us-gov-west-1", description = "AWS GovCloud (US-West)" }
  }
  override_data {
    target = data.aws_partition.this
    values = { partition = "aws-us-gov" }
  }
  assert {
    condition     = [for v in one(data.aws_iam_policy_document.kms_key-this[0].statement[1].condition).values : v] == ["arn:aws-us-gov:logs:us-gov-west-1:111111111111:log-group:*"]
    error_message = "The CloudWatch Logs condition must use the partition."
  }
}

# A KMS key, billed monthly, was created with only the required inputs.
run "kms_key_off_by_default" {
  command = plan
  assert {
    condition     = length(aws_kms_key.this) == 0
    error_message = "The KMS key must be opt-in."
  }
}

run "kms_key_when_asked" {
  command = apply
  variables { enable_kms_key_data = true }
  assert {
    condition     = aws_kms_key.this[0].enable_key_rotation && aws_kms_alias.this[0].name == "alias/data-test"
    error_message = "Unexpected KMS key or alias."
  }
  assert {
    condition     = output.metadata.kms_alias.name == "alias/data-test" && output.metadata.kms_key.arn == aws_kms_key.this[0].arn
    error_message = "metadata must include the key and alias."
  }
}
