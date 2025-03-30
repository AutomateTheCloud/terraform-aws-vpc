resource "aws_egress_only_internet_gateway" "this" {
  count  = (var.enable_ipv6 ? 1 : 0)
  vpc_id = aws_vpc.this.id
  tags = merge(
    local.tags,
    tomap({
      "Name" = "${local.vpc.abbr}-${local.aws.region.abbr}",
    })
  )
  provider = aws.this
}
