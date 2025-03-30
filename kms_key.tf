resource "aws_kms_key" "this" {
  count                   = var.enable_kms_key_data ? 1 : 0
  description             = "Data Encryption Key for ${local.vpc.name}"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  tags = merge(
    local.tags
  )
  policy   = jsonencode(jsondecode(data.aws_iam_policy_document.kms_key-this[0].json))
  provider = aws.this
}
moved {
  from = aws_kms_key.this
  to   = aws_kms_key.this[0]
}

resource "aws_kms_alias" "this" {
  count         = var.enable_kms_key_data ? 1 : 0
  name          = "alias/data-${local.vpc.abbr}"
  target_key_id = aws_kms_key.this[0].key_id
  provider      = aws.this
}
moved {
  from = aws_kms_alias.this
  to   = aws_kms_alias.this[0]
}

data "aws_iam_policy_document" "kms_key-this" {
  count = var.enable_kms_key_data ? 1 : 0
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.this.account_id]
    }
    actions = [
      "kms:*"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid    = "Enable CloudWatch Permissions"
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "logs.${local.aws.region.name}.amazonaws.com"
      ]
    }

    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = [
      "*"
    ]
    condition {
      test     = "ArnLike"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values   = ["arn:aws:logs:${local.aws.region.name}:${data.aws_caller_identity.this.account_id}:log-group:*"]
    }
  }

  provider = aws.this
}
