#------------------------------------------------------------------------------
# Subnet - Private - 1
resource "aws_subnet" "private-1" {
  cidr_block                      = cidrsubnet("${var.network_ip_network}/${var.network_ip_netmask}", 3, 0)
  ipv6_cidr_block                 = var.enable_ipv6 ? cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, 0) : null
  availability_zone               = var.network_availability_zones[0]
  vpc_id                          = aws_vpc.this.id
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = var.enable_ipv6 ? true : false
  tags = merge(
    local.tags,
    tomap({
      "Name"            = "${local.vpc.abbr}-private-1-${local.aws.region.abbr}",
      "Network"         = "private",
      "NetworkLocation" = "az1",
    })
  )
  provider = aws.this
}

#------------------------------------------------------------------------------
# Subnet - Private - 2
resource "aws_subnet" "private-2" {
  cidr_block                      = cidrsubnet("${var.network_ip_network}/${var.network_ip_netmask}", 3, 1)
  ipv6_cidr_block                 = var.enable_ipv6 ? cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, 1) : null
  availability_zone               = var.network_availability_zones[1]
  vpc_id                          = aws_vpc.this.id
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = var.enable_ipv6 ? true : false
  tags = merge(
    local.tags,
    tomap({
      "Name"            = "${local.vpc.abbr}-private-2-${local.aws.region.abbr}",
      "Network"         = "private",
      "NetworkLocation" = "az2",
    })
  )
  provider = aws.this
}

#------------------------------------------------------------------------------
# Subnet - Private - 3
resource "aws_subnet" "private-3" {
  cidr_block                      = cidrsubnet("${var.network_ip_network}/${var.network_ip_netmask}", 3, 2)
  ipv6_cidr_block                 = var.enable_ipv6 ? cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, 2) : null
  availability_zone               = var.network_availability_zones[2]
  vpc_id                          = aws_vpc.this.id
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = var.enable_ipv6 ? true : false
  tags = merge(
    local.tags,
    tomap({
      "Name"            = "${local.vpc.abbr}-private-3-${local.aws.region.abbr}",
      "Network"         = "private",
      "NetworkLocation" = "az3",
    })
  )
  provider = aws.this
}

#------------------------------------------------------------------------------
# Subnet - Restricted - 1
resource "aws_subnet" "restricted-1" {
  cidr_block                      = cidrsubnet("${var.network_ip_network}/${var.network_ip_netmask}", 3, 3)
  ipv6_cidr_block                 = var.enable_ipv6 ? cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, 3) : null
  availability_zone               = var.network_availability_zones[0]
  vpc_id                          = aws_vpc.this.id
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = var.enable_ipv6 ? true : false
  tags = merge(
    local.tags,
    tomap({
      "Name"            = "${local.vpc.abbr}-restricted-1-${local.aws.region.abbr}",
      "Network"         = "restricted",
      "NetworkLocation" = "az1",
    })
  )
  provider = aws.this
}

#------------------------------------------------------------------------------
# Subnet - Restricted - 2
resource "aws_subnet" "restricted-2" {
  cidr_block                      = cidrsubnet("${var.network_ip_network}/${var.network_ip_netmask}", 3, 4)
  ipv6_cidr_block                 = var.enable_ipv6 ? cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, 4) : null
  availability_zone               = var.network_availability_zones[1]
  vpc_id                          = aws_vpc.this.id
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = var.enable_ipv6 ? true : false
  tags = merge(
    local.tags,
    tomap({
      "Name"            = "${local.vpc.abbr}-restricted-2-${local.aws.region.abbr}",
      "Network"         = "restricted",
      "NetworkLocation" = "az2",
    })
  )
  provider = aws.this
}

#------------------------------------------------------------------------------
# Subnet - Restricted - 3
resource "aws_subnet" "restricted-3" {
  cidr_block                      = cidrsubnet("${var.network_ip_network}/${var.network_ip_netmask}", 3, 5)
  ipv6_cidr_block                 = var.enable_ipv6 ? cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, 5) : null
  availability_zone               = var.network_availability_zones[2]
  vpc_id                          = aws_vpc.this.id
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = var.enable_ipv6 ? true : false
  tags = merge(
    local.tags,
    tomap({
      "Name"            = "${local.vpc.abbr}-restricted-3-${local.aws.region.abbr}",
      "Network"         = "restricted",
      "NetworkLocation" = "az3",
    })
  )
  provider = aws.this
}

#------------------------------------------------------------------------------
# Subnet - Public - 1
resource "aws_subnet" "public-1" {
  cidr_block                      = cidrsubnet("${var.network_ip_network}/${var.network_ip_netmask}", 4, 12)
  ipv6_cidr_block                 = var.enable_ipv6 ? cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, 12) : null
  availability_zone               = var.network_availability_zones[0]
  vpc_id                          = aws_vpc.this.id
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = var.enable_ipv6 ? true : false
  tags = merge(
    local.tags,
    tomap({
      "Name"            = "${local.vpc.abbr}-public-1-${local.aws.region.abbr}",
      "Network"         = "public",
      "NetworkLocation" = "az1",
    })
  )
  provider = aws.this
}

#------------------------------------------------------------------------------
# Subnet - Public - 2
resource "aws_subnet" "public-2" {
  cidr_block                      = cidrsubnet("${var.network_ip_network}/${var.network_ip_netmask}", 4, 13)
  ipv6_cidr_block                 = var.enable_ipv6 ? cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, 13) : null
  availability_zone               = var.network_availability_zones[1]
  vpc_id                          = aws_vpc.this.id
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = var.enable_ipv6 ? true : false
  tags = merge(
    local.tags,
    tomap({
      "Name"            = "${local.vpc.abbr}-public-2-${local.aws.region.abbr}",
      "Network"         = "public",
      "NetworkLocation" = "az2",
    })
  )
  provider = aws.this
}

#------------------------------------------------------------------------------
# Subnet - Public - 3
resource "aws_subnet" "public-3" {
  cidr_block                      = cidrsubnet("${var.network_ip_network}/${var.network_ip_netmask}", 4, 14)
  ipv6_cidr_block                 = var.enable_ipv6 ? cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, 14) : null
  availability_zone               = var.network_availability_zones[2]
  vpc_id                          = aws_vpc.this.id
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = var.enable_ipv6 ? true : false
  tags = merge(
    local.tags,
    tomap({
      "Name"            = "${local.vpc.abbr}-public-3-${local.aws.region.abbr}",
      "Network"         = "public",
      "NetworkLocation" = "az3",
    })
  )
  provider = aws.this
}
