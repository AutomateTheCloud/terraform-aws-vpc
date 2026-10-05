# Complete VPC

A VPC with most of the module's options:

- The `10.20.0.0/16` address range.
- IPv6: an Amazon-provided `/56` for the VPC and a `/64` for each subnet, and an egress-only internet gateway for the private tier.
- S3 and DynamoDB gateway endpoints on the private and restricted tiers only.
- The data KMS key.
- Flow logs for all traffic, delivered to an S3 bucket created with the [Automate the Cloud S3 bucket module](https://registry.terraform.io/modules/AutomateTheCloud/s3_bucket/aws). The bucket is versioned, keeps logs for a year, and its policy lets the log delivery service write only on behalf of this account.

The bucket and the VPC are created in the same run.

## Run it

```shell
terraform init
terraform apply -var 'flow_log_bucket_name=<a globally unique bucket name>'
```

Remove it with `terraform destroy` and the same `-var`. Destroying the bucket fails while it still holds flow logs, so that logs are never deleted by accident: empty the bucket first. The KMS key is deleted 10 days after the destroy.

<!-- BEGIN_TF_DOCS -->
### Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement_terraform) (>= 1.9)

- <a name="requirement_aws"></a> [aws](#requirement_aws) (~> 6.0)

### Required Inputs

The following input variables are required:

#### <a name="input_flow_log_bucket_name"></a> [flow_log_bucket_name](#input_flow_log_bucket_name)

Description: Name of the flow log bucket, which must be globally unique

Type: `string`

### Outputs

The following outputs are exported:

#### <a name="output_db_subnet_group"></a> [db_subnet_group](#output_db_subnet_group)

Description: Name of the DB subnet group for the restricted subnets

#### <a name="output_kms_key_alias"></a> [kms_key_alias](#output_kms_key_alias)

Description: Alias of the data KMS key

#### <a name="output_vpc"></a> [vpc](#output_vpc)

Description: The VPC's ID, IPv4 block and IPv6 block
<!-- END_TF_DOCS -->
