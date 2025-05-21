resource_group_name = "learn_databricks_staging"
location = "eastasia"
prefix = "ldbs-stg"
disable_public_ip = false
pricing_tier = "premium"
public_network_access = "Enabled"
vnet_cidr = "10.30.0.0/16"
public_subnet_cidr = "10.30.1.0/24"
private_subnet_cidr = "10.30.2.0/24"
private_endpoint_subnet_cidr = "10.30.3.0/27"

tags = {
  Environment = "Staging"
  Project     = "Azure Databricks"
  Owner       = "DevOpsTeam"
}
