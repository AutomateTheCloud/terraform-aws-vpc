resource "aws_network_acl" "private" {
  vpc_id = aws_vpc.this.id
  subnet_ids = [
    aws_subnet.private-1.id,
    aws_subnet.private-2.id,
    aws_subnet.private-3.id
  ]
  tags = merge(
    local.tags,
    tomap({
      "Name"    = "${local.vpc.abbr}-private-${local.aws.region.abbr}",
      "Network" = "private",
    })
  )
  depends_on = [
    aws_subnet.private-1,
    aws_subnet.private-2,
    aws_subnet.private-3
  ]
  provider = aws.this
}

resource "aws_network_acl" "restricted" {
  vpc_id = aws_vpc.this.id
  subnet_ids = [
    aws_subnet.restricted-1.id,
    aws_subnet.restricted-2.id,
    aws_subnet.restricted-3.id
  ]
  tags = merge(
    local.tags,
    tomap({
      "Name"    = "${local.vpc.abbr}-restricted-${local.aws.region.abbr}",
      "Network" = "restricted",
    })
  )
  depends_on = [
    aws_subnet.restricted-1,
    aws_subnet.restricted-2,
    aws_subnet.restricted-3
  ]
  provider = aws.this
}

resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.this.id
  subnet_ids = [
    aws_subnet.public-1.id,
    aws_subnet.public-2.id,
    aws_subnet.public-3.id
  ]
  tags = merge(
    local.tags,
    tomap({
      "Name"    = "${local.vpc.abbr}-public-${local.aws.region.abbr}",
      "Network" = "public",
    })
  )
  depends_on = [
    aws_subnet.public-1,
    aws_subnet.public-2,
    aws_subnet.public-3
  ]
  provider = aws.this
}
