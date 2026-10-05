# Copyright 2025 Automate the Cloud Inc.
# SPDX-License-Identifier: Apache-2.0


# IPv4: public subnets reach the internet through the internet gateway. Restricted
# subnets do too when enable_igw_on_restricted_subnets is true. Private subnets have
# no IPv4 route out; add a NAT gateway route to their route tables if they need one.

resource "aws_route" "internet_gateway-public-1-ipv4" {
  region                 = var.region
  route_table_id         = aws_route_table.public-1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route" "internet_gateway-public-2-ipv4" {
  region                 = var.region
  route_table_id         = aws_route_table.public-2.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route" "internet_gateway-public-3-ipv4" {
  region                 = var.region
  route_table_id         = aws_route_table.public-3.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route" "internet_gateway-restricted-1-ipv4" {
  count                  = var.enable_igw_on_restricted_subnets ? 1 : 0
  region                 = var.region
  route_table_id         = aws_route_table.restricted-1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route" "internet_gateway-restricted-2-ipv4" {
  count                  = var.enable_igw_on_restricted_subnets ? 1 : 0
  region                 = var.region
  route_table_id         = aws_route_table.restricted-2.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route" "internet_gateway-restricted-3-ipv4" {
  count                  = var.enable_igw_on_restricted_subnets ? 1 : 0
  region                 = var.region
  route_table_id         = aws_route_table.restricted-3.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

# IPv6: public subnets use the internet gateway. Private subnets, and restricted subnets
# when enable_igw_on_restricted_subnets is true, use the egress-only internet gateway,
# which allows connections out but not in.

resource "aws_route" "internet_gateway-public-1-ipv6" {
  count                       = var.enable_ipv6 ? 1 : 0
  region                      = var.region
  route_table_id              = aws_route_table.public-1.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.this.id
}

resource "aws_route" "internet_gateway-public-2-ipv6" {
  count                       = var.enable_ipv6 ? 1 : 0
  region                      = var.region
  route_table_id              = aws_route_table.public-2.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.this.id
}

resource "aws_route" "internet_gateway-public-3-ipv6" {
  count                       = var.enable_ipv6 ? 1 : 0
  region                      = var.region
  route_table_id              = aws_route_table.public-3.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.this.id
}

resource "aws_route" "internet_gateway-private-1-ipv6" {
  count                       = var.enable_ipv6 ? 1 : 0
  region                      = var.region
  route_table_id              = aws_route_table.private-1.id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.this[0].id
}

resource "aws_route" "internet_gateway-private-2-ipv6" {
  count                       = var.enable_ipv6 ? 1 : 0
  region                      = var.region
  route_table_id              = aws_route_table.private-2.id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.this[0].id
}

resource "aws_route" "internet_gateway-private-3-ipv6" {
  count                       = var.enable_ipv6 ? 1 : 0
  region                      = var.region
  route_table_id              = aws_route_table.private-3.id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.this[0].id
}

resource "aws_route" "internet_gateway-restricted-1-ipv6" {
  count                       = var.enable_ipv6 && var.enable_igw_on_restricted_subnets ? 1 : 0
  region                      = var.region
  route_table_id              = aws_route_table.restricted-1.id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.this[0].id
}

resource "aws_route" "internet_gateway-restricted-2-ipv6" {
  count                       = var.enable_ipv6 && var.enable_igw_on_restricted_subnets ? 1 : 0
  region                      = var.region
  route_table_id              = aws_route_table.restricted-2.id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.this[0].id
}

resource "aws_route" "internet_gateway-restricted-3-ipv6" {
  count                       = var.enable_ipv6 && var.enable_igw_on_restricted_subnets ? 1 : 0
  region                      = var.region
  route_table_id              = aws_route_table.restricted-3.id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.this[0].id
}
