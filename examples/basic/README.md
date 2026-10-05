# Basic VPC

A VPC with only the required inputs, in the first three Availability Zones of `us-east-1`: the `172.16.0.0/16` range, nine subnets in three tiers, and S3 and DynamoDB gateway endpoints.

The network ACLs have no rules, so no traffic reaches or leaves the subnets until you add some. The [network ACL rules example](https://github.com/AutomateTheCloud/terraform-aws-vpc/tree/main/examples/network-acl-rules) shows how.

## Run it

```shell
terraform init
terraform apply
```

Remove it with `terraform destroy`.

<!-- BEGIN_TF_DOCS -->
### Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement_terraform) (>= 1.9)

- <a name="requirement_aws"></a> [aws](#requirement_aws) (~> 6.0)

### Outputs

The following outputs are exported:

#### <a name="output_subnet_ids"></a> [subnet_ids](#output_subnet_ids)

Description: Subnet IDs by tier, in Availability Zone order

#### <a name="output_vpc_id"></a> [vpc_id](#output_vpc_id)

Description: ID of the VPC
<!-- END_TF_DOCS -->
