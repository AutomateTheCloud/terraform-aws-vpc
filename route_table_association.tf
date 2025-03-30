resource "aws_route_table_association" "private-1" {
  subnet_id      = aws_subnet.private-1.id
  route_table_id = aws_route_table.private-1.id
  provider       = aws.this
}

resource "aws_route_table_association" "private-2" {
  subnet_id      = aws_subnet.private-2.id
  route_table_id = aws_route_table.private-2.id
  provider       = aws.this
}

resource "aws_route_table_association" "private-3" {
  subnet_id      = aws_subnet.private-3.id
  route_table_id = aws_route_table.private-3.id
  provider       = aws.this
}

resource "aws_route_table_association" "restricted-1" {
  subnet_id      = aws_subnet.restricted-1.id
  route_table_id = aws_route_table.restricted-1.id
  provider       = aws.this
}

resource "aws_route_table_association" "restricted-2" {
  subnet_id      = aws_subnet.restricted-2.id
  route_table_id = aws_route_table.restricted-2.id
  provider       = aws.this
}

resource "aws_route_table_association" "restricted-3" {
  subnet_id      = aws_subnet.restricted-3.id
  route_table_id = aws_route_table.restricted-3.id
  provider       = aws.this
}

resource "aws_route_table_association" "public-1" {
  subnet_id      = aws_subnet.public-1.id
  route_table_id = aws_route_table.public-1.id
  provider       = aws.this
}

resource "aws_route_table_association" "public-2" {
  subnet_id      = aws_subnet.public-2.id
  route_table_id = aws_route_table.public-2.id
  provider       = aws.this
}

resource "aws_route_table_association" "public-3" {
  subnet_id      = aws_subnet.public-3.id
  route_table_id = aws_route_table.public-3.id
  provider       = aws.this
}
