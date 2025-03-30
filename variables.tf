variable "enable_igw_on_restricted_subnets" {
  description = "Enable IGW routing on Restricted Subnets"
  type        = bool
  default     = false
}

variable "enable_ipv6" {
  description = "Enable IPv6"
  type        = bool
  default     = false
}

variable "enable_kms_key_data" {
  description = "Enable KMS Key - Data"
  type        = bool
  default     = true
}

variable "flow_log" {
  description = "Flow Log"
  type        = any
  default     = null
}

variable "network_availability_zones" {
  description = "Network Availability Zones (3 zones required)"
  type        = list(any)
  default     = []
  validation {
    condition     = length(var.network_availability_zones) == 3
    error_message = "Invalid number of Availability Zones (should be 3)."
  }
}

variable "network_acl_egress_use_default_all" {
  description = "Network ACL Egress: Use Default All"
  type        = bool
  default     = false
}

variable "network_acl_ingress_use_default_all" {
  description = "Network ACL Ingress: Use Default All"
  type        = bool
  default     = false
}

variable "network_ip_netmask" {
  description = "Network IP netmask"
  type        = number
  default     = "16"
}

variable "network_ip_network" {
  description = "Network IP network CIDR"
  type        = string
  default     = "172.16.0.0"
}

variable "vpc_name" {
  description = "VPC Name"
  type        = string
  default     = ""
  validation {
    condition     = var.vpc_name != ""
    error_message = "VPC ID not Specified."
  }
}
