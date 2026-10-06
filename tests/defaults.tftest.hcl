# Copyright 2026 Automate the Cloud Inc.
# SPDX-License-Identifier: Apache-2.0

# Offline tests: every provider is mocked, so no AWS account is used.
mock_provider "aws" {
  mock_data "aws_region" {
    defaults = { region = "us-east-1", description = "US East (N. Virginia)" }
  }
  mock_data "aws_caller_identity" {
    defaults = { account_id = "111111111111" }
  }
}

variables {
  details                    = { scope = "Test", purpose = "Defaults", environment = "test" }
  vpc_name                   = "Shared Services"
  network_availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

run "defaults_are_locked_down" {
  command = plan

  assert {
    condition = alltrue([
      length(aws_network_acl_rule.private-ingress-v4) == 0,
      length(aws_network_acl_rule.private-egress-v4) == 0,
      length(aws_network_acl_rule.restricted-ingress-v4) == 0,
      length(aws_network_acl_rule.restricted-egress-v4) == 0,
      length(aws_network_acl_rule.public-ingress-v4) == 0,
      length(aws_network_acl_rule.public-egress-v4) == 0,
    ])
    error_message = "The network ACLs must have no rules by default."
  }
  assert {
    condition     = length(aws_default_security_group.this.ingress) == 0 && length(aws_default_security_group.this.egress) == 0
    error_message = "The default security group must have no rules."
  }
  assert {
    condition = alltrue([
      length(aws_route.internet_gateway-restricted-1-ipv4) == 0,
      length(aws_route.internet_gateway-restricted-2-ipv4) == 0,
      length(aws_route.internet_gateway-restricted-3-ipv4) == 0,
    ])
    error_message = "Restricted subnets must have no internet route by default."
  }
  assert {
    condition = alltrue([
      !aws_subnet.private-1.map_public_ip_on_launch,
      !aws_subnet.private-2.map_public_ip_on_launch,
      !aws_subnet.private-3.map_public_ip_on_launch,
      !aws_subnet.restricted-1.map_public_ip_on_launch,
      !aws_subnet.restricted-2.map_public_ip_on_launch,
      !aws_subnet.restricted-3.map_public_ip_on_launch,
    ])
    error_message = "Private and restricted subnets must not assign public IP addresses."
  }
  assert {
    condition = alltrue([
      length(aws_kms_key.this) == 0,
      length(aws_kms_alias.this) == 0,
      length(aws_flow_log.s3) == 0,
      length(aws_egress_only_internet_gateway.this) == 0,
      length(aws_route.internet_gateway-private-1-ipv6) == 0,
    ])
    error_message = "Optional resources must not be created by default."
  }
  assert {
    condition     = output.metadata.kms_key == null && output.metadata.flow_log == null && output.metadata.egress_only_internet_gateway == null
    error_message = "Entries for resources that are not created must be null."
  }
}

run "address_layout" {
  command = plan

  assert {
    condition     = aws_vpc.this.cidr_block == "172.16.0.0/16"
    error_message = "Unexpected VPC block."
  }
  assert {
    condition = [
      aws_subnet.private-1.cidr_block, aws_subnet.private-2.cidr_block, aws_subnet.private-3.cidr_block,
      aws_subnet.restricted-1.cidr_block, aws_subnet.restricted-2.cidr_block, aws_subnet.restricted-3.cidr_block,
      aws_subnet.public-1.cidr_block, aws_subnet.public-2.cidr_block, aws_subnet.public-3.cidr_block,
      ] == [
      "172.16.0.0/19", "172.16.32.0/19", "172.16.64.0/19",
      "172.16.96.0/19", "172.16.128.0/19", "172.16.160.0/19",
      "172.16.192.0/20", "172.16.208.0/20", "172.16.224.0/20",
    ]
    error_message = "Subnet blocks do not match the documented layout."
  }
  assert {
    condition     = [aws_subnet.public-1.availability_zone, aws_subnet.public-2.availability_zone, aws_subnet.public-3.availability_zone] == ["us-east-1a", "us-east-1b", "us-east-1c"]
    error_message = "Subnets are not spread across the Availability Zones in order."
  }
}

run "names_and_tags" {
  command = plan

  assert {
    condition     = aws_vpc.this.tags["Name"] == "shared_services-use1"
    error_message = "Unexpected VPC Name tag: ${aws_vpc.this.tags["Name"]}."
  }
  assert {
    condition     = aws_db_subnet_group.private.name == "shared_services-db-private-use1"
    error_message = "Unexpected DB subnet group name."
  }
  assert {
    condition     = aws_elasticache_subnet_group.private.name == "sharedservices-elasticache-private-use1"
    error_message = "Unexpected ElastiCache subnet group name."
  }
  assert {
    condition     = aws_subnet.restricted-2.tags["Network"] == "restricted" && aws_subnet.restricted-2.tags["NetworkLocation"] == "az2" && aws_subnet.restricted-2.tags["Scope"] == "Test"
    error_message = "Subnet tags are missing."
  }
}

run "public_subnets_assign_public_ips" {
  command = plan

  assert {
    condition     = aws_subnet.public-1.map_public_ip_on_launch && aws_subnet.public-2.map_public_ip_on_launch && aws_subnet.public-3.map_public_ip_on_launch
    error_message = "Public subnets assign public IPv4 addresses (documented behavior)."
  }
  assert {
    condition     = aws_route.internet_gateway-public-1-ipv4.destination_cidr_block == "0.0.0.0/0"
    error_message = "Public subnets must route to the internet gateway."
  }
}

run "endpoints_on_every_tier_by_default" {
  command = apply

  assert {
    condition     = length(aws_vpc_endpoint.s3.route_table_ids) == 9 && length(aws_vpc_endpoint.dynamodb.route_table_ids) == 9
    error_message = "The gateway endpoints must be on all nine route tables by default."
  }
  assert {
    condition     = aws_vpc_endpoint.s3.service_name == "com.amazonaws.us-east-1.s3" && aws_vpc_endpoint.s3.vpc_endpoint_type == "Gateway"
    error_message = "Unexpected S3 endpoint."
  }
  assert {
    condition     = output.metadata.subnet.private.ids == [aws_subnet.private-1.id, aws_subnet.private-2.id, aws_subnet.private-3.id]
    error_message = "metadata.subnet.private.ids is wrong."
  }
}

run "endpoints_on_selected_tiers" {
  command = apply
  variables {
    vpc_endpoint_route_tables = ["private"]
  }
  assert {
    condition     = toset(aws_vpc_endpoint.s3.route_table_ids) == toset([aws_route_table.private-1.id, aws_route_table.private-2.id, aws_route_table.private-3.id])
    error_message = "The S3 endpoint must be on the private route tables only."
  }
}
