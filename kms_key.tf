# Copyright 2025 Automate the Cloud Inc.
# SPDX-License-Identifier: Apache-2.0

# An optional key for encrypting data that workloads in this VPC store, such as
# CloudWatch Logs log groups. Nothing in this module uses it.
resource "aws_kms_key" "this" {
  count                   = var.enable_kms_key_data ? 1 : 0
  region                  = var.region
  description             = "Data Encryption Key for ${local.vpc.name}"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.kms_key-this[0].json
  tags                    = local.tags
}

data "aws_service_principal" "logs" {
  count        = var.enable_kms_key_data ? 1 : 0
  region       = var.region
  service_name = "logs"
}

data "aws_iam_policy_document" "kms_key-this" {
  count = var.enable_kms_key_data ? 1 : 0

  # The account's IAM policies decide who else may use the key.
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [local.aws.account.id]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  # CloudWatch Logs may use the key, but only for log groups in this account and Region.
  statement {
    sid    = "Enable CloudWatch Permissions"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = [data.aws_service_principal.logs[0].name]
    }
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = ["*"]
    condition {
      test     = "ArnLike"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values   = ["arn:${data.aws_partition.this.partition}:logs:${local.aws.region.name}:${local.aws.account.id}:log-group:*"]
    }
  }
}
