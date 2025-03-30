resource "aws_vpc" "this" {
  cidr_block           = "${var.network_ip_network}/${var.network_ip_netmask}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  assign_generated_ipv6_cidr_block = var.enable_ipv6

  tags = merge(
    local.tags,
    tomap({
      "Name" = "${local.vpc.abbr}-${local.aws.region.abbr}",
    })
  )
  provider = aws.this
}
