#------------------------------------------------------------------------------
# ElastiCache Subnet Group - Private
resource "aws_elasticache_subnet_group" "private" {
  name        = "${local.vpc.machine}-elasticache-private-${local.aws.region.abbr}"
  description = "${local.vpc.name} - ElastiCache Private - ${local.aws.region.name}"
  subnet_ids = [
    aws_subnet.private-1.id,
    aws_subnet.private-2.id,
    aws_subnet.private-3.id
  ]
  depends_on = [
    aws_subnet.private-1,
    aws_subnet.private-2,
    aws_subnet.private-3
  ]
  provider = aws.this
}

#------------------------------------------------------------------------------
# ElastiCache Subnet Group - Restricted
resource "aws_elasticache_subnet_group" "restricted" {
  name        = "${local.vpc.machine}-elasticache-restricted-${local.aws.region.abbr}"
  description = "${local.vpc.name} - ElastiCache Restricted - ${local.aws.region.name}"
  subnet_ids = [
    aws_subnet.restricted-1.id,
    aws_subnet.restricted-2.id,
    aws_subnet.restricted-3.id
  ]
  depends_on = [
    aws_subnet.restricted-1,
    aws_subnet.restricted-2,
    aws_subnet.restricted-3
  ]
  provider = aws.this
}

#------------------------------------------------------------------------------
# ElastiCache Subnet Group - Public
resource "aws_elasticache_subnet_group" "public" {
  name        = "${local.vpc.machine}-elasticache-public-${local.aws.region.abbr}"
  description = "${local.vpc.name} - ElastiCache Public - ${local.aws.region.name}"
  subnet_ids = [
    aws_subnet.public-1.id,
    aws_subnet.public-2.id,
    aws_subnet.public-3.id
  ]
  depends_on = [
    aws_subnet.public-1,
    aws_subnet.public-2,
    aws_subnet.public-3
  ]
  provider = aws.this
}
