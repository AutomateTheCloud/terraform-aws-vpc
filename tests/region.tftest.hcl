# Copyright 2026 Automate the Cloud Inc.
# SPDX-License-Identifier: Apache-2.0

# The module uses the default aws provider: no run here passes a providers block.
mock_provider "aws" {
  mock_data "aws_region" {
    defaults = { region = "us-east-1", description = "US East (N. Virginia)" }
  }
  mock_data "aws_caller_identity" {
    defaults = { account_id = "111111111111" }
  }
  mock_data "aws_iam_policy_document" {
    defaults = { json = "{\"Version\":\"2012-10-17\",\"Statement\":[]}" }
  }
  mock_data "aws_service_principal" {
    defaults = { name = "logs.amazonaws.com" }
  }
  mock_resource "aws_vpc" {
    defaults = { ipv6_cidr_block = "2600:1f18:1234:5600::/56" }
  }
}

variables {
  details                    = { scope = "Test", purpose = "Region", environment = "test" }
  vpc_name                   = "Test"
  network_availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

run "provider_region_by_default" {
  command = plan
  assert {
    condition     = output.metadata.aws.region.name == "us-east-1" && output.metadata.aws.region.abbr == "use1"
    error_message = "Expected the provider's Region."
  }
}

# 74 resources, with every option on.
run "region_reaches_every_resource" {
  command = apply
  variables {
    region                              = "us-west-2"
    enable_ipv6                         = true
    enable_igw_on_restricted_subnets    = true
    enable_kms_key_data                 = true
    network_acl_ingress_use_default_all = true
    network_acl_egress_use_default_all  = true
    flow_log                            = { s3_bucket_arn = "arn:aws:s3:::my-flow-logs" }
  }
  override_data {
    target = data.aws_region.this
    values = { region = "us-west-2", description = "US West (Oregon)" }
  }
  assert {
    condition = alltrue([
      aws_vpc.this.region == "us-west-2",
      aws_internet_gateway.this.region == "us-west-2",
      aws_egress_only_internet_gateway.this[0].region == "us-west-2",
      aws_default_network_acl.this.region == "us-west-2",
      aws_default_route_table.this.region == "us-west-2",
      aws_default_security_group.this.region == "us-west-2",
      aws_vpc_endpoint.s3.region == "us-west-2",
      aws_vpc_endpoint.dynamodb.region == "us-west-2",
      aws_kms_key.this[0].region == "us-west-2",
      aws_kms_alias.this[0].region == "us-west-2",
      aws_flow_log.s3[0].region == "us-west-2",
      aws_network_acl.private.region == "us-west-2",
      aws_db_subnet_group.private.region == "us-west-2",
      aws_elasticache_subnet_group.private.region == "us-west-2",
      aws_network_acl_rule.private-ingress-v4[0].region == "us-west-2",
      aws_network_acl_rule.private-ingress-v6[0].region == "us-west-2",
      aws_network_acl_rule.private-egress-v4[0].region == "us-west-2",
      aws_network_acl_rule.private-egress-v6[0].region == "us-west-2",
      aws_subnet.private-1.region == "us-west-2",
      aws_route_table.private-1.region == "us-west-2",
      aws_route_table_association.private-1.region == "us-west-2",
      aws_route.internet_gateway-private-1-ipv6[0].region == "us-west-2",
      aws_subnet.private-2.region == "us-west-2",
      aws_route_table.private-2.region == "us-west-2",
      aws_route_table_association.private-2.region == "us-west-2",
      aws_route.internet_gateway-private-2-ipv6[0].region == "us-west-2",
      aws_subnet.private-3.region == "us-west-2",
      aws_route_table.private-3.region == "us-west-2",
      aws_route_table_association.private-3.region == "us-west-2",
      aws_route.internet_gateway-private-3-ipv6[0].region == "us-west-2",
      aws_network_acl.restricted.region == "us-west-2",
      aws_db_subnet_group.restricted.region == "us-west-2",
      aws_elasticache_subnet_group.restricted.region == "us-west-2",
      aws_network_acl_rule.restricted-ingress-v4[0].region == "us-west-2",
      aws_network_acl_rule.restricted-ingress-v6[0].region == "us-west-2",
      aws_network_acl_rule.restricted-egress-v4[0].region == "us-west-2",
      aws_network_acl_rule.restricted-egress-v6[0].region == "us-west-2",
      aws_subnet.restricted-1.region == "us-west-2",
      aws_route_table.restricted-1.region == "us-west-2",
      aws_route_table_association.restricted-1.region == "us-west-2",
      aws_route.internet_gateway-restricted-1-ipv6[0].region == "us-west-2",
      aws_route.internet_gateway-restricted-1-ipv4[0].region == "us-west-2",
      aws_subnet.restricted-2.region == "us-west-2",
      aws_route_table.restricted-2.region == "us-west-2",
      aws_route_table_association.restricted-2.region == "us-west-2",
      aws_route.internet_gateway-restricted-2-ipv6[0].region == "us-west-2",
      aws_route.internet_gateway-restricted-2-ipv4[0].region == "us-west-2",
      aws_subnet.restricted-3.region == "us-west-2",
      aws_route_table.restricted-3.region == "us-west-2",
      aws_route_table_association.restricted-3.region == "us-west-2",
      aws_route.internet_gateway-restricted-3-ipv6[0].region == "us-west-2",
      aws_route.internet_gateway-restricted-3-ipv4[0].region == "us-west-2",
      aws_network_acl.public.region == "us-west-2",
      aws_db_subnet_group.public.region == "us-west-2",
      aws_elasticache_subnet_group.public.region == "us-west-2",
      aws_network_acl_rule.public-ingress-v4[0].region == "us-west-2",
      aws_network_acl_rule.public-ingress-v6[0].region == "us-west-2",
      aws_network_acl_rule.public-egress-v4[0].region == "us-west-2",
      aws_network_acl_rule.public-egress-v6[0].region == "us-west-2",
      aws_subnet.public-1.region == "us-west-2",
      aws_route_table.public-1.region == "us-west-2",
      aws_route_table_association.public-1.region == "us-west-2",
      aws_route.internet_gateway-public-1-ipv6[0].region == "us-west-2",
      aws_route.internet_gateway-public-1-ipv4.region == "us-west-2",
      aws_subnet.public-2.region == "us-west-2",
      aws_route_table.public-2.region == "us-west-2",
      aws_route_table_association.public-2.region == "us-west-2",
      aws_route.internet_gateway-public-2-ipv6[0].region == "us-west-2",
      aws_route.internet_gateway-public-2-ipv4.region == "us-west-2",
      aws_subnet.public-3.region == "us-west-2",
      aws_route_table.public-3.region == "us-west-2",
      aws_route_table_association.public-3.region == "us-west-2",
      aws_route.internet_gateway-public-3-ipv6[0].region == "us-west-2",
      aws_route.internet_gateway-public-3-ipv4.region == "us-west-2",
    ])
    error_message = "region was not passed through to every resource."
  }
  assert {
    condition     = data.aws_region.this.region == "us-west-2" && data.aws_service_principal.logs[0].region == "us-west-2"
    error_message = "region was not passed to the data sources."
  }
  assert {
    condition     = aws_vpc_endpoint.s3.service_name == "com.amazonaws.us-west-2.s3" && aws_vpc.this.tags["Name"] == "test-usw2"
    error_message = "Names must follow the module's Region."
  }
}

# Any Region plans, including ones added after this module was written.
run "region_not_in_old_table" {
  command = plan
  override_data {
    target = data.aws_region.this
    values = { region = "ap-east-2", description = "Asia Pacific (Taipei)" }
  }
  assert {
    condition     = output.metadata.aws.region.abbr == "ape2" && aws_vpc.this.tags["Name"] == "test-ape2"
    error_message = "Unexpected abbreviation."
  }
}

run "region_abbreviation_matches_old_table" {
  command = plan
  override_data {
    target = data.aws_region.this
    values = { region = "ap-southeast-7", description = "Asia Pacific (Thailand)" }
  }
  assert {
    condition     = output.metadata.aws.region.abbr == "apse7"
    error_message = "Unexpected abbreviation."
  }
}

run "region_abbreviation_override" {
  command = plan
  override_data {
    target = data.aws_region.this
    values = { region = "us-gov-west-1", description = "AWS GovCloud (US-West)" }
  }
  assert {
    condition     = output.metadata.aws.region.abbr == "ugw1"
    error_message = "Unexpected abbreviation."
  }
}
