resource_group_name = "learn_databricks_prod"
location = "eastasia"
prefix = "ldbs-prod"
disable_public_ip = true
pricing_tier = "premium"
public_network_access = "Disabled"
vnet_cidr = "10.40.0.0/16"
public_subnet_cidr = "10.40.1.0/24"
private_subnet_cidr = "10.40.2.0/24"
private_endpoint_subnet_cidr = "10.40.3.0/27"

tags = {
  Environment = "Production"
  Project     = "Azure Databricks"
  Owner       = "ProdOpsTeam"
}
