# Copyright 2026 Automate the Cloud Inc.
# SPDX-License-Identifier: Apache-2.0

# A VPC whose flow log bucket is named in the same run, so its ARN is not known until
# apply, as when the bucket is created alongside the VPC.

terraform {
  required_version = ">= 1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}

resource "random_id" "bucket" {
  byte_length = 4
}

module "vpc" {
  source = "../../.."

  details                    = { scope = "Test", purpose = "Flow Logs", environment = "test" }
  vpc_name                   = "Test"
  network_availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  flow_log                   = { s3_bucket_arn = "arn:aws:s3:::flow-logs-${random_id.bucket.hex}" }
}
