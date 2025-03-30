resource "aws_route_table" "private-1" {
  vpc_id = aws_vpc.this.id
  tags = merge(
    local.tags,
    tomap({
      "Name"    = "${local.vpc.abbr}-private-1-${local.aws.region.abbr}",
      "Network" = "private",
    })
  )
  provider = aws.this
}

resource "aws_route_table" "private-2" {
  vpc_id = aws_vpc.this.id
  tags = merge(
    local.tags,
    tomap({
      "Name"    = "${local.vpc.abbr}-private-2-${local.aws.region.abbr}",
      "Network" = "private",
    })
  )
  provider = aws.this
}

resource "aws_route_table" "private-3" {
  vpc_id = aws_vpc.this.id
  tags = merge(
    local.tags,
    tomap({
      "Name"    = "${local.vpc.abbr}-private-3-${local.aws.region.abbr}",
      "Network" = "private",
    })
  )
  provider = aws.this
}

resource "aws_route_table" "restricted-1" {
  vpc_id = aws_vpc.this.id
  tags = merge(
    local.tags,
    tomap({
      "Name"    = "${local.vpc.abbr}-restricted-1-${local.aws.region.abbr}",
      "Network" = "restricted",
    })
  )
  provider = aws.this
}

resource "aws_route_table" "restricted-2" {
  vpc_id = aws_vpc.this.id
  tags = merge(
    local.tags,
    tomap({
      "Name"    = "${local.vpc.abbr}-restricted-2-${local.aws.region.abbr}",
      "Network" = "restricted",
    })
  )
  provider = aws.this
}

resource "aws_route_table" "restricted-3" {
  vpc_id = aws_vpc.this.id
  tags = merge(
    local.tags,
    tomap({
      "Name"    = "${local.vpc.abbr}-restricted-3-${local.aws.region.abbr}",
      "Network" = "restricted",
    })
  )
  provider = aws.this
}

resource "aws_route_table" "public-1" {
  vpc_id = aws_vpc.this.id
  tags = merge(
    local.tags,
    tomap({
      "Name"    = "${local.vpc.abbr}-public-1-${local.aws.region.abbr}",
      "Network" = "public",
    })
  )
  provider = aws.this
}

resource "aws_route_table" "public-2" {
  vpc_id = aws_vpc.this.id
  tags = merge(
    local.tags,
    tomap({
      "Name"    = "${local.vpc.abbr}-public-2-${local.aws.region.abbr}",
      "Network" = "public",
    })
  )
  provider = aws.this
}

resource "aws_route_table" "public-3" {
  vpc_id = aws_vpc.this.id
  tags = merge(
    local.tags,
    tomap({
      "Name"    = "${local.vpc.abbr}-public-3-${local.aws.region.abbr}",
      "Network" = "public",
    })
  )
  provider = aws.this
}
