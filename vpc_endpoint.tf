#------------------------------------------------------------------------------
# VPC Endpoint - S3
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.this.id
  vpc_endpoint_type = "Gateway"
  service_name      = "com.amazonaws.${local.aws.region.name}.s3"
  route_table_ids = [
    aws_route_table.private-1.id,
    aws_route_table.private-2.id,
    aws_route_table.private-3.id,
    aws_route_table.restricted-1.id,
    aws_route_table.restricted-2.id,
    aws_route_table.restricted-3.id,
    aws_route_table.public-1.id,
    aws_route_table.public-2.id,
    aws_route_table.public-3.id
  ]
  tags = merge(
    local.tags,
    tomap({
      "Name" = "${local.vpc.abbr}-s3-${local.aws.region.abbr}",
    })
  )
  provider = aws.this
}

#------------------------------------------------------------------------------
# VPC Endpoint - DynamoDB
resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id            = aws_vpc.this.id
  vpc_endpoint_type = "Gateway"
  service_name      = "com.amazonaws.${local.aws.region.name}.dynamodb"
  route_table_ids = [
    aws_route_table.private-1.id,
    aws_route_table.private-2.id,
    aws_route_table.private-3.id,
    aws_route_table.restricted-1.id,
    aws_route_table.restricted-2.id,
    aws_route_table.restricted-3.id,
    aws_route_table.public-1.id,
    aws_route_table.public-2.id,
    aws_route_table.public-3.id
  ]
  tags = merge(
    local.tags,
    tomap({
      "Name" = "${local.vpc.abbr}-dynamodb-${local.aws.region.abbr}",
    })
  )
  provider = aws.this
}
