locals {
  vpc = {
    name    = var.vpc_name
    abbr    = lower(replace(trimspace(replace(replace(var.vpc_name, "/[^0-9A-Za-z]/", " "), "/ {1,}/g", " ")), "/\\s{1,}/", "_"))
    machine = lower(replace(var.vpc_name, "/[^0-9A-Za-z]/", ""))
  }
}
