# Copyright 2026 Automate the Cloud Inc.
# SPDX-License-Identifier: Apache-2.0

resource "aws_route_table_association" "private-1" {
  region         = var.region
  subnet_id      = aws_subnet.private-1.id
  route_table_id = aws_route_table.private-1.id
}

resource "aws_route_table_association" "private-2" {
  region         = var.region
  subnet_id      = aws_subnet.private-2.id
  route_table_id = aws_route_table.private-2.id
}

resource "aws_route_table_association" "private-3" {
  region         = var.region
  subnet_id      = aws_subnet.private-3.id
  route_table_id = aws_route_table.private-3.id
}

resource "aws_route_table_association" "restricted-1" {
  region         = var.region
  subnet_id      = aws_subnet.restricted-1.id
  route_table_id = aws_route_table.restricted-1.id
}

resource "aws_route_table_association" "restricted-2" {
  region         = var.region
  subnet_id      = aws_subnet.restricted-2.id
  route_table_id = aws_route_table.restricted-2.id
}

resource "aws_route_table_association" "restricted-3" {
  region         = var.region
  subnet_id      = aws_subnet.restricted-3.id
  route_table_id = aws_route_table.restricted-3.id
}

resource "aws_route_table_association" "public-1" {
  region         = var.region
  subnet_id      = aws_subnet.public-1.id
  route_table_id = aws_route_table.public-1.id
}

resource "aws_route_table_association" "public-2" {
  region         = var.region
  subnet_id      = aws_subnet.public-2.id
  route_table_id = aws_route_table.public-2.id
}

resource "aws_route_table_association" "public-3" {
  region         = var.region
  subnet_id      = aws_subnet.public-3.id
  route_table_id = aws_route_table.public-3.id
}
