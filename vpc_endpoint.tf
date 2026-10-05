# Copyright 2025 Automate the Cloud Inc.
# SPDX-License-Identifier: Apache-2.0

#------------------------------------------------------------------------------
# VPC Endpoint - S3
resource "aws_vpc_endpoint" "s3" {
  region            = var.region
  vpc_id            = aws_vpc.this.id
  vpc_endpoint_type = "Gateway"
  service_name      = "com.amazonaws.${local.aws.region.name}.s3"
  route_table_ids   = local.vpc_endpoint_route_table_ids
  tags = merge(
    local.tags,
    {
      "Name" = "${local.vpc.abbr}-s3-${local.aws.region.abbr}",
    }
  )
}

#------------------------------------------------------------------------------
# VPC Endpoint - DynamoDB
resource "aws_vpc_endpoint" "dynamodb" {
  region            = var.region
  vpc_id            = aws_vpc.this.id
  vpc_endpoint_type = "Gateway"
  service_name      = "com.amazonaws.${local.aws.region.name}.dynamodb"
  route_table_ids   = local.vpc_endpoint_route_table_ids
  tags = merge(
    local.tags,
    {
      "Name" = "${local.vpc.abbr}-dynamodb-${local.aws.region.abbr}",
    }
  )
}
