# Copyright 2026 Automate the Cloud Inc.
# SPDX-License-Identifier: Apache-2.0

# A VPC with most options on: a chosen address range, IPv6, the data KMS key, gateway
# endpoints on the private and restricted tiers only, and flow logs to an S3 bucket.
#
# The flow log bucket is made with the Automate the Cloud S3 bucket module. Its policy
# lets the log delivery service write flow logs for this account only, under the
# AWSLogs/<account ID>/ prefix, and is passed in through policy.source_policy_documents.

terraform {
  required_version = ">= 1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

variable "flow_log_bucket_name" {
  description = "Name of the flow log bucket, which must be globally unique"
  type        = string
}

data "aws_availability_zones" "available" {
  state = "available"
}
data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}

locals {
  details = {
    scope       = "Example"
    purpose     = "Complete VPC"
    environment = "Development"
    additional_tags = {
      CostCenter = "1234"
    }
  }

  account_id      = data.aws_caller_identity.current.account_id
  flow_log_bucket = "arn:${data.aws_partition.current.partition}:s3:::${var.flow_log_bucket_name}"
  source_arn      = "arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.region}:${local.account_id}:*"
}

# What VPC flow log delivery needs: to check the bucket's ACL, and to write objects
# under AWSLogs/<account ID>/. Both only on behalf of this account.
data "aws_iam_policy_document" "flow_log_delivery" {
  statement {
    sid       = "AWSLogDeliveryWrite"
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["${local.flow_log_bucket}/AWSLogs/${local.account_id}/*"]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [local.account_id]
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [local.source_arn]
    }
  }

  statement {
    sid       = "AWSLogDeliveryAclCheck"
    effect    = "Allow"
    actions   = ["s3:GetBucketAcl", "s3:ListBucket"]
    resources = [local.flow_log_bucket]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [local.account_id]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [local.source_arn]
    }
  }
}

module "flow_log_bucket" {
  source  = "AutomateTheCloud/s3_bucket/aws"
  version = "~> 1.0"

  details    = local.details
  name       = var.flow_log_bucket_name
  versioning = { enabled = true }

  # Flow logs are kept for a year. Versioning keeps a deleted or overwritten log for 30
  # more days.
  lifecycle_rules = [
    {
      rule_name                              = "Expire flow logs"
      enabled                                = true
      abort_incomplete_multipart_upload_days = 7
      expiration                             = { days = 365 }
      noncurrent_version_expiration          = { days = 30 }
    }
  ]

  policy = {
    source_policy_documents = [data.aws_iam_policy_document.flow_log_delivery.json]
  }
}

module "vpc" {
  source = "../../"

  details = local.details

  vpc_name                   = "Example"
  network_availability_zones = slice(data.aws_availability_zones.available.names, 0, 3)
  network_ip_network         = "10.20.0.0"
  network_ip_netmask         = 16

  enable_ipv6               = true
  enable_kms_key_data       = true
  vpc_endpoint_route_tables = ["private", "restricted"]

  flow_log = {
    s3_bucket_arn = module.flow_log_bucket.metadata.s3_bucket.arn
    traffic_type  = "ALL"
  }
}

output "vpc" {
  description = "The VPC's ID, IPv4 block and IPv6 block"
  value = {
    id              = module.vpc.metadata.vpc.id
    cidr_block      = module.vpc.metadata.vpc.cidr_block
    ipv6_cidr_block = module.vpc.metadata.vpc.ipv6_cidr_block
  }
}

output "db_subnet_group" {
  description = "Name of the DB subnet group for the restricted subnets"
  value       = module.vpc.metadata.db_subnet_group.restricted.name
}

output "kms_key_alias" {
  description = "Alias of the data KMS key"
  value       = module.vpc.metadata.kms_alias.name
}
