#------------------------------------------------------------------------------
# DB Subnet Group - Private
resource "aws_db_subnet_group" "private" {
  name        = "${local.vpc.abbr}-db-private-${local.aws.region.abbr}"
  description = "${local.vpc.name} - DB Private - ${local.aws.region.name}"
  subnet_ids = [
    aws_subnet.private-1.id,
    aws_subnet.private-2.id,
    aws_subnet.private-3.id
  ]
  tags = merge(
    local.tags,
    tomap({
      "Name" = "${local.vpc.abbr}-db-private-${local.aws.region.abbr}",
    })
  )
  depends_on = [
    aws_subnet.private-1,
    aws_subnet.private-2,
    aws_subnet.private-3
  ]
  provider = aws.this
}

#------------------------------------------------------------------------------
# DB Subnet Group - Restricted
resource "aws_db_subnet_group" "restricted" {
  name        = "${local.vpc.abbr}-db-restricted-${local.aws.region.abbr}"
  description = "${local.vpc.name} - DB Restricted - ${local.aws.region.name}"
  subnet_ids = [
    aws_subnet.restricted-1.id,
    aws_subnet.restricted-2.id,
    aws_subnet.restricted-3.id
  ]
  tags = merge(
    local.tags,
    tomap({
      "Name" = "${local.vpc.abbr}-db-restricted-${local.aws.region.abbr}",
    })
  )
  depends_on = [
    aws_subnet.restricted-1,
    aws_subnet.restricted-2,
    aws_subnet.restricted-3
  ]
  provider = aws.this
}

#------------------------------------------------------------------------------
# DB Subnet Group - Public
resource "aws_db_subnet_group" "public" {
  name        = "${local.vpc.abbr}-db-public-${local.aws.region.abbr}"
  description = "${local.vpc.name} - DB Public - ${local.aws.region.name}"
  subnet_ids = [
    aws_subnet.public-1.id,
    aws_subnet.public-2.id,
    aws_subnet.public-3.id
  ]
  tags = merge(
    local.tags,
    tomap({
      "Name" = "${local.vpc.abbr}-db-public-${local.aws.region.abbr}",
    })
  )
  depends_on = [
    aws_subnet.public-1,
    aws_subnet.public-2,
    aws_subnet.public-3
  ]
  provider = aws.this
}
