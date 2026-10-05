# Network ACL rules

A VPC with network ACL rules added to the module's network ACLs, which start with none:

- Every tier allows TCP and UDP to and from addresses inside the VPC.
- The public tier also allows HTTPS in from the internet, and the replies out.

Network ACLs are stateless, so the reply to each allowed request needs its own rule. Replies go to the client's ephemeral port, from 1024 to 65535. Security groups still decide which instances accept which traffic; network ACLs are a second, subnet-wide layer.

The rules use numbers 100 to 200. The module's own allow-all rules, when turned on, are 1000 and 1001.

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

#### <a name="output_network_acl_ids"></a> [network_acl_ids](#output_network_acl_ids)

Description: Network ACL IDs by tier
<!-- END_TF_DOCS -->
