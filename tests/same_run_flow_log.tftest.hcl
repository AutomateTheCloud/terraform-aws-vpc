# Copyright 2025 Automate the Cloud Inc.
# SPDX-License-Identifier: Apache-2.0

mock_provider "aws" {
  mock_data "aws_region" {
    defaults = { region = "us-east-1", description = "US East (N. Virginia)" }
  }
  mock_data "aws_caller_identity" {
    defaults = { account_id = "111111111111" }
  }
}
mock_provider "random" {}

# flow_log.s3_bucket_arn can refer to a bucket created in the same run, whose ARN is not
# known until apply.
run "flow_log_bucket_created_in_same_run" {
  command   = plan
  providers = { aws = aws, random = random }
  module {
    source = "./tests/fixtures/same_run_flow_log"
  }
  assert {
    condition     = length(module.vpc.metadata.flow_log[*]) == 1
    error_message = "The flow log was not planned."
  }
}
