# Copyright 2026 Automate the Cloud Inc.
# SPDX-License-Identifier: Apache-2.0

resource "aws_network_acl_rule" "private-ingress-v4" {
  count          = var.network_acl_ingress_use_default_all ? 1 : 0
  region         = var.region
  network_acl_id = aws_network_acl.private.id
  rule_number    = 1000
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "private-egress-v4" {
  count          = var.network_acl_egress_use_default_all ? 1 : 0
  region         = var.region
  network_acl_id = aws_network_acl.private.id
  egress         = true
  rule_number    = 1000
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "restricted-ingress-v4" {
  count          = var.network_acl_ingress_use_default_all ? 1 : 0
  region         = var.region
  network_acl_id = aws_network_acl.restricted.id
  rule_number    = 1000
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "restricted-egress-v4" {
  count          = var.network_acl_egress_use_default_all ? 1 : 0
  region         = var.region
  network_acl_id = aws_network_acl.restricted.id
  egress         = true
  rule_number    = 1000
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "public-ingress-v4" {
  count          = var.network_acl_ingress_use_default_all ? 1 : 0
  region         = var.region
  network_acl_id = aws_network_acl.public.id
  rule_number    = 1000
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "public-egress-v4" {
  count          = var.network_acl_egress_use_default_all ? 1 : 0
  region         = var.region
  network_acl_id = aws_network_acl.public.id
  egress         = true
  rule_number    = 1000
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "private-ingress-v6" {
  count           = var.network_acl_ingress_use_default_all && var.enable_ipv6 ? 1 : 0
  region          = var.region
  network_acl_id  = aws_network_acl.private.id
  rule_number     = 1001
  protocol        = -1
  rule_action     = "allow"
  ipv6_cidr_block = "::/0"
  from_port       = 0
  to_port         = 0
}

resource "aws_network_acl_rule" "private-egress-v6" {
  count           = var.network_acl_egress_use_default_all && var.enable_ipv6 ? 1 : 0
  region          = var.region
  network_acl_id  = aws_network_acl.private.id
  egress          = true
  rule_number     = 1001
  protocol        = -1
  rule_action     = "allow"
  ipv6_cidr_block = "::/0"
  from_port       = 0
  to_port         = 0
}

resource "aws_network_acl_rule" "restricted-ingress-v6" {
  count           = var.network_acl_ingress_use_default_all && var.enable_ipv6 ? 1 : 0
  region          = var.region
  network_acl_id  = aws_network_acl.restricted.id
  rule_number     = 1001
  protocol        = -1
  rule_action     = "allow"
  ipv6_cidr_block = "::/0"
  from_port       = 0
  to_port         = 0
}

resource "aws_network_acl_rule" "restricted-egress-v6" {
  count           = var.network_acl_egress_use_default_all && var.enable_ipv6 ? 1 : 0
  region          = var.region
  network_acl_id  = aws_network_acl.restricted.id
  egress          = true
  rule_number     = 1001
  protocol        = -1
  rule_action     = "allow"
  ipv6_cidr_block = "::/0"
  from_port       = 0
  to_port         = 0
}

resource "aws_network_acl_rule" "public-ingress-v6" {
  count           = var.network_acl_ingress_use_default_all && var.enable_ipv6 ? 1 : 0
  region          = var.region
  network_acl_id  = aws_network_acl.public.id
  rule_number     = 1001
  protocol        = -1
  rule_action     = "allow"
  ipv6_cidr_block = "::/0"
  from_port       = 0
  to_port         = 0
}

resource "aws_network_acl_rule" "public-egress-v6" {
  count           = var.network_acl_egress_use_default_all && var.enable_ipv6 ? 1 : 0
  region          = var.region
  network_acl_id  = aws_network_acl.public.id
  egress          = true
  rule_number     = 1001
  protocol        = -1
  rule_action     = "allow"
  ipv6_cidr_block = "::/0"
  from_port       = 0
  to_port         = 0
}
