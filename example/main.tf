terraform {
  required_version = "~> 1.11.0"
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

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
  enable_ipv6                         = true
  enable_kms_key_data                 = false
}

output "vpc" {
  description = "VPC"
  value = module.vpc.metadata
}
