resource "aws_default_route_table" "this" {
  default_route_table_id = aws_vpc.this.default_route_table_id
  tags = merge(
    local.tags,
    tomap({
      "Name"   = "${local.vpc.abbr}-default-${local.aws.region.abbr}",
      "Active" = "false",
      "Note"   = "DO NOT USE OR MODIFY",
    })
  )
  depends_on = [
    aws_vpc.this
  ]
  provider = aws.this
}
