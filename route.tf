resource "aws_route" "internet_gateway-public-1-ipv4" {
  route_table_id         = aws_route_table.public-1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
  provider               = aws.this
}
moved {
  from = aws_route.internet_gateway-public-1
  to   = aws_route.internet_gateway-public-1-ipv4
}

resource "aws_route" "internet_gateway-public-2-ipv4" {
  route_table_id         = aws_route_table.public-2.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
  provider               = aws.this
}
moved {
  from = aws_route.internet_gateway-public-2
  to   = aws_route.internet_gateway-public-2-ipv4
}

resource "aws_route" "internet_gateway-public-3-ipv4" {
  route_table_id         = aws_route_table.public-3.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
  provider               = aws.this
}
moved {
  from = aws_route.internet_gateway-public-3
  to   = aws_route.internet_gateway-public-3-ipv4
}

resource "aws_route" "internet_gateway-restricted-1-ipv4" {
  count                  = (var.enable_igw_on_restricted_subnets ? 1 : 0)
  route_table_id         = aws_route_table.restricted-1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
  provider               = aws.this
}
moved {
  from = aws_route.internet_gateway-restricted-1[0]
  to   = aws_route.internet_gateway-restricted-1-ipv4[0]
}

resource "aws_route" "internet_gateway-restricted-2-ipv4" {
  count                  = (var.enable_igw_on_restricted_subnets ? 1 : 0)
  route_table_id         = aws_route_table.restricted-2.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
  provider               = aws.this
}
moved {
  from = aws_route.internet_gateway-restricted-2[0]
  to   = aws_route.internet_gateway-restricted-2-ipv4[0]
}

resource "aws_route" "internet_gateway-restricted-3-ipv4" {
  count                  = (var.enable_igw_on_restricted_subnets ? 1 : 0)
  route_table_id         = aws_route_table.restricted-3.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
  provider               = aws.this
}
moved {
  from = aws_route.internet_gateway-restricted-3[0]
  to   = aws_route.internet_gateway-restricted-3-ipv4[0]
}

resource "aws_route" "internet_gateway-public-1-ipv6" {
  count                       = (var.enable_ipv6 ? 1 : 0)
  route_table_id              = aws_route_table.public-1.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.this.id
  provider                    = aws.this
}

resource "aws_route" "internet_gateway-public-2-ipv6" {
  count                       = (var.enable_ipv6 ? 1 : 0)
  route_table_id              = aws_route_table.public-2.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.this.id
  provider                    = aws.this
}

resource "aws_route" "internet_gateway-public-3-ipv6" {
  count                       = (var.enable_ipv6 ? 1 : 0)
  route_table_id              = aws_route_table.public-3.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.this.id
  provider                    = aws.this
}

resource "aws_route" "internet_gateway-private-1-ipv6" {
  count                       = (var.enable_ipv6 ? 1 : 0)
  route_table_id              = aws_route_table.private-1.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_egress_only_internet_gateway.this[0].id
  provider                    = aws.this
}

resource "aws_route" "internet_gateway-private-2-ipv6" {
  count                       = (var.enable_ipv6 ? 1 : 0)
  route_table_id              = aws_route_table.private-2.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_egress_only_internet_gateway.this[0].id
  provider                    = aws.this
}

resource "aws_route" "internet_gateway-private-3-ipv6" {
  count                       = (var.enable_ipv6 ? 1 : 0)
  route_table_id              = aws_route_table.private-3.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_egress_only_internet_gateway.this[0].id
  provider                    = aws.this
}

resource "aws_route" "internet_gateway-restricted-1-ipv6" {
  count                       = (var.enable_ipv6 && var.enable_igw_on_restricted_subnets ? 1 : 0)
  route_table_id              = aws_route_table.restricted-1.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_egress_only_internet_gateway.this[0].id
  provider                    = aws.this
}

resource "aws_route" "internet_gateway-restricted-2-ipv6" {
  count                       = (var.enable_ipv6 && var.enable_igw_on_restricted_subnets ? 1 : 0)
  route_table_id              = aws_route_table.restricted-2.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_egress_only_internet_gateway.this[0].id
  provider                    = aws.this
}

resource "aws_route" "internet_gateway-restricted-3-ipv6" {
  count                       = (var.enable_ipv6 && var.enable_igw_on_restricted_subnets ? 1 : 0)
  route_table_id              = aws_route_table.restricted-3.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_egress_only_internet_gateway.this[0].id
  provider                    = aws.this
}
