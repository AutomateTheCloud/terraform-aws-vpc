# Changelog

All notable changes to this module are listed here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the module uses [semantic versioning](https://semver.org/): a new major version means callers must change their code.

## [Unreleased]

## [1.0.0] - 2026-10-05

Initial release.

### Added

- A VPC with nine subnets in three tiers (`private`, `restricted` and `public`) across three Availability Zones, a route table per subnet, and a network ACL, DB subnet group and ElastiCache subnet group per tier.
- Locked-down defaults: network ACLs with no rules, and the default security group and default network ACL emptied of rules.
- An internet gateway for the public tier, and an optional internet route for the restricted tier.
- IPv6, with an egress-only internet gateway for the private tier.
- S3 and DynamoDB gateway endpoints, on the route tables of the tiers you choose.
- Flow logs to an S3 bucket, and an optional KMS key for data.
- Validation of the address range, Availability Zones and flow log settings at plan time.
- `region`, to create the VPC in a Region other than the provider's.
- A `metadata` output with everything the module created.
- Offline tests, and examples for a basic VPC, network ACL rules, and most options together.

[Unreleased]: https://github.com/AutomateTheCloud/terraform-aws-vpc/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/AutomateTheCloud/terraform-aws-vpc/releases/tag/v1.0.0
