# Terraform module for Amazon VPC

Creates an Amazon Virtual Private Cloud (VPC) with nine subnets: three tiers, `private`, `restricted` and `public`, each with one subnet in each of three Availability Zones. Each subnet gets its own route table. Each tier gets a network ACL, a DB subnet group and an ElastiCache subnet group. The module also creates an internet gateway, S3 and DynamoDB gateway endpoints, and, optionally, IPv6, flow logs and a KMS key.

The defaults are locked down. With only the required inputs, the network ACLs have no rules, so they deny all traffic until you add rules for what you need. The VPC's default security group and default network ACL have every rule removed, so nothing can use them by accident.

## What it configures

| Setting | Default | Input |
|---|---|---|
| IPv4 address range | `172.16.0.0/16` | `network_ip_network`, `network_ip_netmask` |
| Availability Zones | Required: three | `network_availability_zones` |
| Network ACL rules | None: all traffic denied | `network_acl_ingress_use_default_all`, `network_acl_egress_use_default_all`, or your own rules |
| Public subnets | Route to the internet gateway; assign public IPv4 addresses | Not configurable |
| Private subnets | No route out of the VPC (IPv6 out only, when IPv6 is on) | Not configurable |
| Restricted subnets | No route out of the VPC | `enable_igw_on_restricted_subnets` |
| IPv6 | Off | `enable_ipv6` |
| S3 and DynamoDB gateway endpoints | On, for all three tiers | `vpc_endpoint_route_tables` |
| Flow logs | Off | `flow_log` |
| KMS key for data | Off | `enable_kms_key_data` |
| Default security group and network ACL | All rules removed | Not configurable |
| DNS resolution and DNS hostnames | On | Not configurable |

## Usage

```hcl
module "vpc" {
  source  = "AutomateTheCloud/vpc/aws"
  version = "~> 1.0"

  details = {
    scope       = "Automate the Cloud"
    purpose     = "Shared Network"
    environment = "Production"
  }

  vpc_name                   = "Shared Services"
  network_availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  network_ip_network         = "10.20.0.0"
  network_ip_netmask         = 16
}
```

`details`, `vpc_name` and `network_availability_zones` are the only required inputs. `details` sets the `Scope`, `Purpose` and `Environment` tags on every resource.

The module uses your default `aws` provider and creates everything in that provider's Region. To create the VPC somewhere else without configuring another provider, set `region`, and choose Availability Zones in that Region:

```hcl
module "vpc_us_west_2" {
  source  = "AutomateTheCloud/vpc/aws"
  version = "~> 1.0"

  region  = "us-west-2"
  details = { scope = "Automate the Cloud", purpose = "Disaster Recovery", environment = "Production" }

  vpc_name                   = "Recovery"
  network_availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
  network_ip_network         = "10.21.0.0"
}
```

To use a provider configured for another account, pass it explicitly with `providers = { aws = aws.other_account }`.

Everything the module creates is in its `metadata` output. For example, `module.vpc.metadata.vpc.id` is the VPC ID, `module.vpc.metadata.subnet.private.ids` lists the three private subnet IDs, and `module.vpc.metadata.db_subnet_group.restricted.name` names the DB subnet group for the restricted tier.

## The `details` input

Most modules ask only for what the resource itself needs. This one also requires `details`: three names that say what the VPC belongs to, what it is for, and which environment it is in. Every Automate the Cloud module takes the same input, and requiring it is deliberate.

```hcl
details = {
  scope       = "Automate the Cloud" # what it belongs to: an organization, team or project
  purpose     = "Shared Network"     # what it is for
  environment = "Production"         # which environment
}
```

**Every resource can be traced.** The three names become the `Scope`, `Purpose` and `Environment` tags on every resource the module creates. Months later, anyone looking at a VPC in the AWS console, or at a line on the bill, can see who it belongs to and why it exists. With cost allocation tags turned on in AWS Billing, the same tags split your bill by project and environment. Because the input is required and checked, no resource can be created without them.

**One definition for a whole stack.** Write `details` once and pass the same value to every module, so the VPC, its DNS zone and everything else are tagged alike. Tags you want everywhere, such as a cost center or the Terraform workspace, go in `additional_tags`:

```hcl
locals {
  details = {
    scope           = "Automate the Cloud"
    purpose         = "Shared Network"
    environment     = "Production"
    additional_tags = { CostCenter = "1234", IaC = "true" }
  }
}

module "vpc" {
  source  = "AutomateTheCloud/vpc/aws"
  version = "~> 1.0"

  details                    = local.details
  vpc_name                   = "Shared Services"
  network_availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
```

**Consistent names.** The module turns each name into two short forms other resources can be named with: `abbr`, lowercase with words joined by underscores (`Shared Network` becomes `shared_network`), and `machine`, lowercase letters and numbers only (`sharednetwork`), for resources that allow no underscores. It also works out a short form of the Region, such as `use1` for `us-east-1`. Every module derives these the same way, so names stay consistent across a stack. To choose your own short forms, set `scope_abbr`, `purpose_abbr` or `environment_abbr`, for example `environment_abbr = "prd"`.

**One output to reach everything.** All of it comes back in the `metadata` output, along with everything the module created, so a configuration needs only one reference: `module.vpc.metadata.vpc.id` for the VPC's ID, or `module.vpc.metadata.aws.region.abbr` for the Region's short form.

## Examples

Each example is a complete configuration you can run with `terraform init` and `terraform apply`.

- [Basic VPC](https://github.com/AutomateTheCloud/terraform-aws-vpc/tree/main/examples/basic): only the required inputs.
- [Network ACL rules](https://github.com/AutomateTheCloud/terraform-aws-vpc/tree/main/examples/network-acl-rules): rules that allow traffic inside the VPC, and HTTPS from the internet to the public tier.
- [Complete](https://github.com/AutomateTheCloud/terraform-aws-vpc/tree/main/examples/complete): most of the module's options, with flow logs delivered to an S3 bucket.

## Things to know

### The network ACLs deny everything until you add rules

Each tier has its own network ACL, and the module adds no rules to them. Until you do, no traffic reaches or leaves any subnet, even when a security group allows it. Add rules with `aws_network_acl_rule`, using the IDs in `metadata.network_acl`, as the [network ACL rules example](https://github.com/AutomateTheCloud/terraform-aws-vpc/tree/main/examples/network-acl-rules) does. Network ACLs are stateless: a rule that lets a request in does not let its reply out, so each direction needs a rule.

`network_acl_ingress_use_default_all` and `network_acl_egress_use_default_all` add rules that allow all traffic from and to anywhere. They leave security groups as the only filter. The module uses rule numbers 1000 and 1001 for them, so give your own rules other numbers.

### The three tiers

| Tier | IPv4 route out | IPv6 route out, when `enable_ipv6` is on | Public IPv4 addresses | Use for |
|---|---|---|---|---|
| `public` | Internet gateway | Internet gateway | Assigned to every instance | Load balancers, NAT gateways, bastion hosts |
| `private` | None | Egress-only internet gateway: out, but not in | Never | Application servers and internal services |
| `restricted` | None, or the internet gateway with `enable_igw_on_restricted_subnets` | None, or the egress-only internet gateway with `enable_igw_on_restricted_subnets` | Never | Databases and services that should not reach the internet |

The module creates no NAT gateway. To let private subnets reach the internet over IPv4, create a NAT gateway in a public subnet and add a `0.0.0.0/0` route to it in each private route table: `metadata.route_table.private.1.id`, `.2.id` and `.3.id`.

Every instance launched in a public subnet gets a public IPv4 address, and AWS bills for each public IPv4 address by the hour. Put instances that do not need to be reached from the internet in the private or restricted tier.

### Address layout

The VPC's IPv4 block is split into equal eighths. The private and restricted subnets get one eighth each, and the public subnets one sixteenth each. One sixteenth at the end stays free. For the default `172.16.0.0/16`:

| Subnet | Size | Addresses |
|---|---|---|
| `private` 1, 2, 3 | `/19` | `172.16.0.0/19`, `172.16.32.0/19`, `172.16.64.0/19` |
| `restricted` 1, 2, 3 | `/19` | `172.16.96.0/19`, `172.16.128.0/19`, `172.16.160.0/19` |
| `public` 1, 2, 3 | `/20` | `172.16.192.0/20`, `172.16.208.0/20`, `172.16.224.0/20` |
| Not used | `/20` | `172.16.240.0/20` |

A larger `network_ip_netmask` scales every subnet down by the same amount: with `/24`, the private and restricted subnets are `/27` and the public subnets `/28`, the smallest AWS allows. With IPv6 on, each subnet gets a `/64` from the VPC's `/56`, numbered the same way.

Changing `network_ip_network`, `network_ip_netmask` or `network_availability_zones` later replaces the VPC or its subnets, and with them everything inside. Choose a range that will not need to change and does not overlap any network you will connect the VPC to.

### Names

Resources are named from `vpc_name` and the Region's short form: with `vpc_name = "Shared Services"` in `us-east-1`, the VPC's `Name` tag is `shared_services-use1`, the first private subnet's is `shared_services-private-1-use1`, and the restricted DB subnet group is `shared_services-db-restricted-use1`. ElastiCache does not allow underscores, so its subnet groups use the letters-and-numbers form: `sharedservices-elasticache-restricted-use1`. Subnets are also tagged `Network` (the tier) and `NetworkLocation` (`az1`, `az2` or `az3`).

Changing `vpc_name` later updates the tags in place, but replaces the DB and ElastiCache subnet groups and the KMS alias, whose names cannot change. AWS does not delete a subnet group that a database or cache cluster is using, so rename a VPC only before anything is placed in it.

### Flow logs

Flow logs record the IP traffic in the VPC, which helps with security investigations and with troubleshooting connections. To turn them on, set `flow_log.s3_bucket_arn` to a bucket whose policy allows the log delivery service to write to it. The [complete example](https://github.com/AutomateTheCloud/terraform-aws-vpc/tree/main/examples/complete) creates such a bucket, with a policy limited to this account. The bucket can be created in the same configuration as the VPC.

### The KMS key

`enable_kms_key_data` creates a customer managed key, with rotation on, for workloads in the VPC to encrypt their data with, such as CloudWatch Logs log groups. Nothing in this module uses it. A KMS key is billed monthly, and destroying it only schedules its deletion, 10 days later.

## Contributing

Contributions are welcome, after review. Read [CONTRIBUTING.md](https://github.com/AutomateTheCloud/terraform-aws-vpc/blob/main/CONTRIBUTING.md) before opening a pull request, and report security problems as described in [SECURITY.md](https://github.com/AutomateTheCloud/terraform-aws-vpc/blob/main/SECURITY.md).

## Testing

The tests in `tests/` run offline against mocked AWS providers, so they need no AWS account:

```shell
terraform init
terraform test
```

## Reference

The sections below are generated from the code by [terraform-docs](https://terraform-docs.io). To update them, run `terraform-docs .`.

<!-- BEGIN_TF_DOCS -->
### Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement_terraform) (>= 1.9)

- <a name="requirement_aws"></a> [aws](#requirement_aws) (>= 6.0)

### Required Inputs

The following input variables are required:

#### <a name="input_details"></a> [details](#input_details)

Description: Names and tags shared by every resource in the module. `scope`, `purpose` and `environment` become the `Scope`, `Purpose` and `Environment` tags, and are converted to abbreviations that other modules can use in resource names (see the `metadata` output). [The `details` input](https://github.com/AutomateTheCloud/terraform-aws-vpc#the-details-input) explains why it is required.

- `scope` - (Required) What the resource belongs to, such as an organization or project: `Automate the Cloud`.
- `purpose` - (Required) What the resource is for: `Shared Network`.
- `environment` - (Required) The environment: `Production`.
- `scope_abbr`, `purpose_abbr`, `environment_abbr` - (Optional) Abbreviations to use instead of the generated ones, which are lowercase with words joined by underscores (`Shared Network` becomes `shared_network`).
- `additional_tags` - (Optional) More tags for every resource, such as `{ CostCenter = "1234" }`.

Type:

```hcl
object({
    scope            = string
    scope_abbr       = optional(string)
    purpose          = string
    purpose_abbr     = optional(string)
    environment      = string
    environment_abbr = optional(string)
    additional_tags  = optional(map(string), {})
  })
```

#### <a name="input_network_availability_zones"></a> [network_availability_zones](#input_network_availability_zones)

Description: The three Availability Zones to place subnets in, one subnet of each tier per zone, such as `["us-east-1a", "us-east-1b", "us-east-1c"]`. They must be in the module's Region and all different.

Type: `list(string)`

#### <a name="input_vpc_name"></a> [vpc_name](#input_vpc_name)

Description: The name of the VPC, such as `Shared Services`. Resource names are built from it: `Name` tags and DB subnet group names use the lowercase form with words joined by underscores (`shared_services`), and ElastiCache subnet group names use letters and numbers only (`sharedservices`).

Type: `string`

### Optional Inputs

The following input variables are optional (have default values):

#### <a name="input_enable_igw_on_restricted_subnets"></a> [enable_igw_on_restricted_subnets](#input_enable_igw_on_restricted_subnets)

Description: Add a default route from the restricted subnets to the internet: `0.0.0.0/0` through the internet gateway, and `::/0` through the egress-only internet gateway when `enable_ipv6` is `true`. Defaults to `false`, so restricted subnets have no route out of the VPC.

Restricted subnets never assign public IPv4 addresses, so an instance there reaches the internet over IPv4 only if it has an Elastic IP address.

Type: `bool`

Default: `false`

#### <a name="input_enable_ipv6"></a> [enable_ipv6](#input_enable_ipv6)

Description: Give the VPC an Amazon-provided IPv6 `/56` block and each subnet a `/64` from it, and assign IPv6 addresses to new network interfaces. Public subnets route `::/0` through the internet gateway; private subnets route it through an egress-only internet gateway, which allows connections out but not in. Defaults to `false`.

Turning it on later updates the VPC and subnets in place.

Type: `bool`

Default: `false`

#### <a name="input_enable_kms_key_data"></a> [enable_kms_key_data](#input_enable_kms_key_data)

Description: Create a customer managed KMS key, with the alias `alias/data-<vpc abbr>`, for encrypting data that workloads in this VPC store. Nothing in this module uses it. The key policy lets the account's IAM policies grant access, and lets CloudWatch Logs use the key for log groups in this account and Region. Key rotation is on, and a deleted key can be recovered for 10 days. Defaults to `false`.

A KMS key is billed monthly while it exists, including while it is scheduled for deletion.

Type: `bool`

Default: `false`

#### <a name="input_flow_log"></a> [flow_log](#input_flow_log)

Description: Send VPC flow logs, a record of the IP traffic in the VPC, to an S3 bucket. Defaults to `null`: no flow logs. The bucket must already allow log delivery; [the complete example](https://github.com/AutomateTheCloud/terraform-aws-vpc/tree/main/examples/complete) shows a bucket policy that does.

- `s3_bucket_arn` - (Required) ARN of the bucket, optionally followed by a folder: `arn:aws:s3:::my-flow-logs` or `arn:aws:s3:::my-flow-logs/vpc`.
- `traffic_type` - (Optional) `ALL`, `ACCEPT` (allowed traffic only) or `REJECT` (rejected traffic only). Defaults to `ALL`.
- `log_format` - (Optional) The fields to record, in flow log format syntax. Defaults to every field up to version 5 of the format, in alphabetical order.
- `max_aggregation_interval` - (Optional) The longest time, in seconds, over which traffic is collected into one record: `60` or `600`. Defaults to `600`.
- `file_format` - (Optional) `plain-text` or `parquet`. Defaults to `plain-text`.
- `hive_compatible_partitions` - (Optional) Use Hive-compatible folder names, such as `year=2025/`, for query tools like Amazon Athena. Defaults to `false`.
- `per_hour_partition` - (Optional) Write one folder per hour instead of one per day. Defaults to `false`.

Type:

```hcl
object({
    s3_bucket_arn              = string
    traffic_type               = optional(string, "ALL")
    log_format                 = optional(string, "$${account-id} $${action} $${az-id} $${bytes} $${dstaddr} $${dstport} $${end} $${flow-direction} $${instance-id} $${interface-id} $${log-status} $${packets} $${pkt-dst-aws-service} $${pkt-dstaddr} $${pkt-src-aws-service} $${pkt-srcaddr} $${protocol} $${region} $${srcaddr} $${srcport} $${start} $${sublocation-id} $${sublocation-type} $${subnet-id} $${tcp-flags} $${traffic-path} $${type} $${version} $${vpc-id}")
    max_aggregation_interval   = optional(number, 600)
    file_format                = optional(string, "plain-text")
    hive_compatible_partitions = optional(bool, false)
    per_hour_partition         = optional(bool, false)
  })
```

Default: `null`

#### <a name="input_network_acl_egress_use_default_all"></a> [network_acl_egress_use_default_all](#input_network_acl_egress_use_default_all)

Description: Add a rule to each subnet tier's network ACL that allows all outbound traffic to anywhere (`0.0.0.0/0`, and `::/0` when `enable_ipv6` is `true`). Defaults to `false`: the network ACLs have no rules, so they deny all traffic until you add your own rules (see [the network ACL rules example](https://github.com/AutomateTheCloud/terraform-aws-vpc/tree/main/examples/network-acl-rules)).

Type: `bool`

Default: `false`

#### <a name="input_network_acl_ingress_use_default_all"></a> [network_acl_ingress_use_default_all](#input_network_acl_ingress_use_default_all)

Description: Add a rule to each subnet tier's network ACL that allows all inbound traffic from anywhere (`0.0.0.0/0`, and `::/0` when `enable_ipv6` is `true`). Defaults to `false`: the network ACLs have no rules, so they deny all traffic until you add your own rules. With this on, security groups are the only traffic filter.

Type: `bool`

Default: `false`

#### <a name="input_network_ip_netmask"></a> [network_ip_netmask](#input_network_ip_netmask)

Description: The prefix length of the VPC's IPv4 block, from `16` (65,536 addresses) to `24` (256 addresses). Defaults to `16`. The smallest subnets are 4 bits longer, and AWS does not allow subnets smaller than `/28`.

Type: `number`

Default: `16`

#### <a name="input_network_ip_network"></a> [network_ip_network](#input_network_ip_network)

Description: The first address of the VPC's IPv4 block, such as `10.20.0.0`. Together with `network_ip_netmask` it forms the block (`10.20.0.0/16`), so it must be the first address of a block of that size. Defaults to `172.16.0.0`. Use a private range (`10.0.0.0/8`, `172.16.0.0/12` or `192.168.0.0/16`) that does not overlap any network you will connect this VPC to.

Type: `string`

Default: `"172.16.0.0"`

#### <a name="input_region"></a> [region](#input_region)

Description: The AWS Region to create the VPC and everything in it in, such as `us-west-2`. Defaults to the Region of the AWS provider passed to the module.

Type: `string`

Default: `null`

#### <a name="input_vpc_endpoint_route_tables"></a> [vpc_endpoint_route_tables](#input_vpc_endpoint_route_tables)

Description: Which subnet tiers' route tables the S3 and DynamoDB gateway endpoints are added to: any of `private`, `restricted` and `public`. Defaults to all three. Traffic to S3 and DynamoDB in the same Region from a listed tier stays on the AWS network, at no charge. An empty list leaves the endpoints on no route tables.

Type: `list(string)`

Default:

```json
[
  "private",
  "restricted",
  "public"
]
```

### Outputs

The following outputs are exported:

#### <a name="output_metadata"></a> [metadata](#output_metadata)

Description: Everything the module created, in one object, so that other configurations need only one reference. Each resource entry lists that resource's attributes, such as `id` and `arn`; an entry is `null` when the resource is not created.

- `details` - The scope, purpose and environment, each with its `name`, `abbr` (lowercase, words joined by underscores) and `machine` (lowercase letters and numbers only) forms, and the `tags` applied to every resource.
- `aws` - The `account.id`, and the `region` `name`, `abbr` (such as `use1` for `us-east-1`) and `description`.
- `vpc` - The VPC, such as `id`, `cidr_block` and `ipv6_cidr_block`, plus the VPC name's `name`, `abbr` and `machine` forms.
- `subnet` - The subnets by tier: `private`, `restricted` and `public`. Each tier has `ids`, a list of its three subnet IDs in Availability Zone order, and `1`, `2` and `3`, one subnet each.
- `route_table` - The route tables, one per subnet, in the same shape as `subnet`.
- `network_acl` - The network ACLs, one per tier: `private`, `restricted` and `public`.
- `db_subnet_group`, `elasticache_subnet_group` - The DB and ElastiCache subnet groups, one per tier, such as `db_subnet_group.private.name`.
- `vpc_endpoint` - The `s3` and `dynamodb` gateway endpoints.
- `internet_gateway` - The internet gateway.
- `egress_only_internet_gateway` - The egress-only internet gateway, created when `enable_ipv6` is `true`.
- `kms_key`, `kms_alias` - The data key and its alias, created when `enable_kms_key_data` is `true`.
- `flow_log` - The flow log, created when `flow_log` is set.
- `default_network_acl`, `default_route_table`, `default_security_group` - The VPC's default network ACL, route table and security group. No subnet uses them. The module removes every rule from the default network ACL and security group, and tags all three `DO NOT USE OR MODIFY`.
<!-- END_TF_DOCS -->

## License

This module is licensed under the [Apache License 2.0](https://github.com/AutomateTheCloud/terraform-aws-vpc/blob/main/LICENSE). See [NOTICE](https://github.com/AutomateTheCloud/terraform-aws-vpc/blob/main/NOTICE) for the copyright notice.

The Automate the Cloud name and logo are not covered by this license.

---

Maintained by [Automate the Cloud](https://automatethe.cloud), a Kentucky 501(c)(3) that teaches cloud infrastructure and helps nonprofits run theirs.
