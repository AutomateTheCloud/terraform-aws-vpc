# AWS - VPC - Terraform Module
Terraform module to create a VPC (AutomateTheCloud model)

***

## Usage
```hcl
module "vpc" {
  source    = "../"
  providers = { aws.this = aws.us-east-1 }
  
  details = {
    scope               = "Demo"
    purpose             = "VPC"
    environment         = "dev"
    additional_tags = {
      "Project"         = "Project Name"
      "ProjectID"       = "123456789"
      "Contact"         = "David Singer - david.singer@example.com"
    }
  }
  
  vpc_name                            = "Demo"

  network_availability_zones          = [ "us-east-1a", "us-east-1b", "us-east-1c" ]
  network_ip_network                  = "172.24.0.0"
  network_ip_netmask                  = "19"
  network_acl_ingress_use_default_all = true
  network_acl_egress_use_default_all  = true
  
  enable_igw_on_restricted_subnets    = false
}
```

***

## Inputs
| Name | Description | Type | Default |
|------|-------------|:----:|:-------:|
| `enable_igw_on_restricted_subnets` | Enable IGW routing on Restricted Subnets | `bool` | `false` |
| `enable_ipv6` | Enable IPv6 | `bool` | `false` |
| `enable_kms_key_data` | Enable KMS Key - Data | `bool` | `true` |
| `network_availability_zones` | (Required) Network Availability Zones (3 zones required) | `list` | `[]` |
| `network_acl_egress_use_default_all` | Network ACL Egress: Use Default All | `bool` | `true` |
| `network_acl_ingress_use_default_all` | Network ACL Ingress: Use Default All | `bool` | `true` |
| `network_ip_netmask` | (Required) Network IP netmask | `number` | `16` |
| `vpc_name` | (Required) VPC Name | `string` | |

## Inputs (Details)
| Name | Description | Type | Default |
|------|-------------|:----:|:-------:|
| `details.scope` | (Required) Scope Name - What does this object belong to? (Organization Name, Project, etc) | `string` | |
| `details.scope_abbr` | (Optional) Scope [Abbreviation](#Abbreviations) Override | `string` | |
| `details.purpose` | (Required) Purpose Name - What is the purpose or function of this object, or what does this object server? | `string` | |
| `details.purpose_abbr` | (Optional) Purpose [Abbreviation](#Abbreviations) Override | `string` | |
| `details.environment` | (Required) Environment Name | `string` | |
| `details.environment_abbr` | (Optional) Environment [Abbreviation](#Abbreviations) Override | `string` | |
| `details.additional_tags` | (Optional) [Additional Tags](#Additional-Tags) for resources | `map` | `[]` |

***

## Outputs
All outputs from this module are mapped to a single output named `metadata` to make it easier to capture all of the relevant metadata that would be useful when referenced by other stacks (requires only a single output reference in your code, instead of dozens!)

| Name | Description |
|:-----|:------------|
| `details.scope.name` | Scope name |
| `details.scope.abbr` | Scope abbreviation |
| `details.scope.machine` | Scope machine-friendly abbreviation |
| `details.purpose.name` | Purpose name |
| `details.purpose.abbr` | Purpose abbreviation |
| `details.purpose.machine` | Purpose machine-friendly abbreviation |
| `details.environment.name` | Environment name |
| `details.environment.abbr` | Environment abbreviation |
| `details.environment.machine` | Environment machine-friendly abbreviation |
| `details.tags` | Map of tags applied to all resources |
| `aws.account.id` | AWS Account ID |
| `aws.region.name` | AWS Region name, example: `us-east-1` |
| `aws.region.abbr` | AWS Region four letter abbreviation, example: `use1` |
| `aws.region.description` | AWS Region description, example: `US East (N. Virginia)` |
| `db_subnet_group.private` | DB Subnet Group (private) |
| `db_subnet_group.restricted` | DB Subnet Group (restricted) |
| `db_subnet_group.public` | DB Subnet Group (public) |
| `elasticache_subnet_group.private` | Elasticache Subnet Group (private) |
| `elasticache_subnet_group.restricted` | Elasticache Subnet Group (restricted) |
| `elasticache_subnet_group.public` | Elasticache Subnet Group (public) |
| `internet_gateway` | Internet Gateway |
| `egress_only_internet_gateway` | Egress Only Internet Gateway |
| `kms.data` | KMS Key - Data |
| `network_acl.private` | Network ACL (private) |
| `network_acl.restricted` | Network ACL (restricted) |
| `network_acl.public` | Network ACL (public) |
| `route_table.private.ids` | Route Table (private) - IDs (list) |
| `route_table.private.1` | Route Table (private) - AZ 1 |
| `route_table.private.2` | Route Table (private) - AZ 2 |
| `route_table.private.3` | Route Table (private) - AZ 3 |
| `route_table.restricted.ids` | Route Table (restricted) - IDs (list) |
| `route_table.restricted.1` | Route Table (restricted) - AZ 1 |
| `route_table.restricted.2` | Route Table (restricted) - AZ 2 |
| `route_table.restricted.3` | Route Table (restricted) - AZ 3 |
| `route_table.public.ids` | Route Table (public) - IDs (list) |
| `route_table.public.1` | Route Table (public) - AZ 1 |
| `route_table.public.2` | Route Table (public) - AZ 2 |
| `route_table.public.3` | Route Table (public) - AZ 3 |
| `subnet.private.ids` | Subnet (private) - IDs (list) |
| `subnet.private.1` | Subnet (private) - AZ 1 |
| `subnet.private.2` | Subnet (private) - AZ 2 |
| `subnet.private.3` | Subnet (private) - AZ 3 |
| `subnet.restricted.ids` | Subnet (restricted) - IDs (list) |
| `subnet.restricted.1` | Subnet (restricted) - AZ 1 |
| `subnet.restricted.2` | Subnet (restricted) - AZ 2 |
| `subnet.restricted.3` | Subnet (restricted) - AZ 3 |
| `subnet.public.ids` | Subnet (public) - IDs (list) |
| `subnet.public.1` | Subnet (public) - AZ 1 |
| `subnet.public.2` | Subnet (public) - AZ 2 |
| `subnet.public.3` | Subnet (public) - AZ 3 |
| `vpc` | VPC |
| `vpc_endpoint.dynamodb` | VPC Endpoint - DynamoDB |
| `vpc_endpoint.s3` | VPC Endpoint - S3 |

***

## Notes

### Abbreviations
* When generating resource names, the module converts each identifier to a more 'machine-friendly' abbreviated format, removing all special characters, replacing spaces with underscores (_), and converting to lowercase. Example: 'Demo - Module' => 'demo_module'
* Not all resource names allow underscores. When those are encountered, the detail identifier will have the underscore removed (test_example => testexample) automatically. This machine-friendly abbreviation is referred to as 'machine' within the module.
* The abbreviations can be overridden by suppling the abbreviated names (ie: scope_abbr). This is useful when you have a long name and need the created resource names to be shorter. Some resources in AWS have shorter name constraints than others, or you may just prefer it shorter. NOTE: If specifying the Abbreviation, be sure to follow the convention of no spaces and no special characters (except for underscore), otherwise resoure creation may fail.

### Additional Tags
* You can specify additional tags for resources by adding to the `details.additional_tags` map.
```
additional_tags = {
  "Example"         = "Extra Tag"
  "Project"         = "Project Name"
  "CostCenter"      = "123456"
}
```

***

## Terraform Versions
Terraform ~> 1.11.0 is supported.

## Provider Versions
| Name | Version |
|------|---------|
| aws | `~> 5.93` |
