# Copyright 2025 Automate the Cloud Inc.
# SPDX-License-Identifier: Apache-2.0

# Each input mistake fails at plan time with a clear message.
mock_provider "aws" {
  mock_data "aws_region" {
    defaults = { region = "us-east-1", description = "US East (N. Virginia)" }
  }
  mock_data "aws_caller_identity" {
    defaults = { account_id = "111111111111" }
  }
}

variables {
  details                    = { scope = "Test", purpose = "Validation", environment = "test" }
  vpc_name                   = "Test"
  network_availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

run "scope_required" {
  command = plan
  variables { details = { scope = " ", purpose = "Validation", environment = "test" } }
  expect_failures = [var.details]
}

run "purpose_required" {
  command = plan
  variables { details = { scope = "Test", purpose = "", environment = "test" } }
  expect_failures = [var.details]
}

run "environment_required" {
  command = plan
  variables { details = { scope = "Test", purpose = "Validation", environment = "" } }
  expect_failures = [var.details]
}

run "vpc_name_needs_a_letter_or_number" {
  command = plan
  variables { vpc_name = " - " }
  expect_failures = [var.vpc_name]
}

run "three_availability_zones" {
  command = plan
  variables { network_availability_zones = ["us-east-1a", "us-east-1b"] }
  expect_failures = [var.network_availability_zones]
}

run "netmask_too_short" {
  command = plan
  variables { network_ip_netmask = 15 }
  expect_failures = [var.network_ip_netmask]
}

run "netmask_not_whole" {
  command = plan
  variables { network_ip_netmask = 16.5 }
  expect_failures = [var.network_ip_netmask]
}

run "netmask_24_is_allowed" {
  command = plan
  variables {
    network_ip_network = "10.1.2.0"
    network_ip_netmask = 24
  }
  assert {
    condition     = aws_subnet.public-3.cidr_block == "10.1.2.224/28"
    error_message = "The smallest subnets at /24 must be /28."
  }
}

run "network_not_an_address" {
  command = plan
  variables { network_ip_network = "10.0.0" }
  expect_failures = [var.network_ip_network]
}

run "network_with_leading_zero" {
  command = plan
  variables { network_ip_network = "010.0.0.0" }
  expect_failures = [var.network_ip_network]
}

run "network_not_first_address" {
  command = plan
  variables { network_ip_network = "172.16.5.0" }
  expect_failures = [var.network_ip_network]
}

run "endpoint_route_table_tier" {
  command = plan
  variables { vpc_endpoint_route_tables = ["private", "isolated"] }
  expect_failures = [var.vpc_endpoint_route_tables]
}

run "flow_log_bucket_arn" {
  command = plan
  variables { flow_log = { s3_bucket_arn = "my-flow-logs" } }
  expect_failures = [var.flow_log]
}

run "flow_log_traffic_type" {
  command = plan
  variables { flow_log = { s3_bucket_arn = "arn:aws:s3:::my-flow-logs", traffic_type = "all" } }
  expect_failures = [var.flow_log]
}

run "flow_log_aggregation_interval" {
  command = plan
  variables { flow_log = { s3_bucket_arn = "arn:aws:s3:::my-flow-logs", max_aggregation_interval = 300 } }
  expect_failures = [var.flow_log]
}

run "flow_log_file_format" {
  command = plan
  variables { flow_log = { s3_bucket_arn = "arn:aws:s3:::my-flow-logs", file_format = "json" } }
  expect_failures = [var.flow_log]
}
