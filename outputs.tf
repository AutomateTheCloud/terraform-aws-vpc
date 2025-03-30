output "metadata" {
  description = "Metadata"
  value = {
    details = {
      scope = {
        name    = local.scope.name
        abbr    = local.scope.abbr
        machine = local.scope.machine
      }
      purpose = {
        name    = local.purpose.name
        abbr    = local.purpose.abbr
        machine = local.purpose.machine
      }
      environment = {
        name    = local.environment.name
        abbr    = local.environment.abbr
        machine = local.environment.machine
      }
      tags = local.tags
    }

    aws = {
      account = {
        id = local.aws.account.id
      }
      region = {
        name        = local.aws.region.name
        abbr        = local.aws.region.abbr
        description = local.aws.region.description
      }
    }

    db_subnet_group = {
      private    = try(aws_db_subnet_group.private, null)
      restricted = try(aws_db_subnet_group.restricted, null)
      public     = try(aws_db_subnet_group.public, null)
    }

    elasticache_subnet_group = {
      private    = try(aws_elasticache_subnet_group.private, null)
      restricted = try(aws_elasticache_subnet_group.restricted, null)
      public     = try(aws_elasticache_subnet_group.public, null)
    }

    internet_gateway             = try(aws_internet_gateway.this, null)
    egress_only_internet_gateway = try(aws_egress_only_internet_gateway.this[0], null)

    kms = {
      data = merge(
        try(aws_kms_key.this[0], null),
        tomap({
          "key_arn"    = try(aws_kms_key.this[0].arn, null),
          "alias_name" = try(aws_kms_alias.this[0].name, null),
          "alias_arn"  = try(aws_kms_alias.this[0].arn, null),
        })
      )
    }

    network_acl = {
      private    = try(aws_network_acl.private, null)
      restricted = try(aws_network_acl.restricted, null)
      public     = try(aws_network_acl.public, null)
    }

    route_table = {
      private = {
        ids = [
          try(aws_route_table.private-1.id, null),
          try(aws_route_table.private-2.id, null),
          try(aws_route_table.private-3.id, null),
        ]
        1 = try(aws_route_table.private-1, null)
        2 = try(aws_route_table.private-2, null)
        3 = try(aws_route_table.private-3, null)
      }
      restricted = {
        ids = [
          try(aws_route_table.restricted-1.id, null),
          try(aws_route_table.restricted-2.id, null),
          try(aws_route_table.restricted-3.id, null),
        ]
        1 = try(aws_route_table.restricted-1, null)
        2 = try(aws_route_table.restricted-2, null)
        3 = try(aws_route_table.restricted-3, null)
      }
      public = {
        ids = [
          try(aws_route_table.public-1.id, null),
          try(aws_route_table.public-2.id, null),
          try(aws_route_table.public-3.id, null),
        ]
        1 = try(aws_route_table.public-1, null)
        2 = try(aws_route_table.public-2, null)
        3 = try(aws_route_table.public-3, null)
      }
    }

    subnet = {
      private = {
        ids = [
          try(aws_subnet.private-1.id, null),
          try(aws_subnet.private-2.id, null),
          try(aws_subnet.private-3.id, null),
        ]
        1 = try(aws_subnet.private-1, null)
        2 = try(aws_subnet.private-2, null)
        3 = try(aws_subnet.private-3, null)
      }
      restricted = {
        ids = [
          try(aws_subnet.restricted-1.id, null),
          try(aws_subnet.restricted-2.id, null),
          try(aws_subnet.restricted-3.id, null),
        ]
        1 = try(aws_subnet.restricted-1, null)
        2 = try(aws_subnet.restricted-2, null)
        3 = try(aws_subnet.restricted-3, null)
      }
      public = {
        ids = [
          try(aws_subnet.public-1.id, null),
          try(aws_subnet.public-2.id, null),
          try(aws_subnet.public-3.id, null),
        ]
        1 = try(aws_subnet.public-1, null)
        2 = try(aws_subnet.public-2, null)
        3 = try(aws_subnet.public-3, null)
      }
    }

    vpc = merge(
      try(aws_vpc.this, null),
      tomap({
        "name"    = local.vpc.name,
        "abbr"    = local.vpc.abbr,
        "machine" = local.vpc.machine,
      })
    )

    vpc_endpoint = {
      dynamodb = try(aws_vpc_endpoint.dynamodb, null)
      s3       = try(aws_vpc_endpoint.s3, null)
    }
  }
}
