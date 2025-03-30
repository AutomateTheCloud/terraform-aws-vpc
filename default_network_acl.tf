resource "aws_default_network_acl" "this" {
  default_network_acl_id = aws_vpc.this.default_network_acl_id
  tags = merge(
    local.tags,
    tomap({
      "Name" = "${local.vpc.abbr}-default-${local.aws.region.abbr}",
      "Note" = "DO NOT USE OR MODIFY",
    })
  )
  depends_on = [
    aws_vpc.this,
    aws_network_acl.private,
    aws_network_acl.restricted,
    aws_network_acl.public
  ]
  provider = aws.this
}
