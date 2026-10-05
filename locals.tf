# Copyright 2025 Automate the Cloud Inc.
# SPDX-License-Identifier: Apache-2.0

locals {
  # The VPC name in the forms used in resource names: abbr is lowercase with words joined
  # by underscores ("Shared Services" becomes "shared_services"), machine is lowercase
  # letters and numbers only ("sharedservices"), for names that cannot hold underscores.
  vpc = {
    name    = var.vpc_name
    abbr    = lower(replace(trimspace(replace(var.vpc_name, "/[^0-9A-Za-z]/", " ")), "/\\s{1,}/", "_"))
    machine = lower(replace(var.vpc_name, "/[^0-9A-Za-z]/", ""))
  }

  cidr_block = "${var.network_ip_network}/${var.network_ip_netmask}"

  # Route tables that the S3 and DynamoDB gateway endpoints are attached to.
  vpc_endpoint_route_table_ids = concat(
    contains(var.vpc_endpoint_route_tables, "private") ? [
      aws_route_table.private-1.id,
      aws_route_table.private-2.id,
      aws_route_table.private-3.id,
    ] : [],
    contains(var.vpc_endpoint_route_tables, "restricted") ? [
      aws_route_table.restricted-1.id,
      aws_route_table.restricted-2.id,
      aws_route_table.restricted-3.id,
    ] : [],
    contains(var.vpc_endpoint_route_tables, "public") ? [
      aws_route_table.public-1.id,
      aws_route_table.public-2.id,
      aws_route_table.public-3.id,
    ] : [],
  )
}
