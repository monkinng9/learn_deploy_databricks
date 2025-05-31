resource_group_name          = "learn_databricks_dev"
location                     = "eastasia"
prefix                       = "ldbs-dev"
disable_public_ip            = false
pricing_tier                 = "premium"
public_network_access        = "Enabled"
vnet_cidr                    = "10.20.0.0/16"
public_subnet_cidr           = "10.20.1.0/24"
private_subnet_cidr          = "10.20.2.0/24"
private_endpoint_subnet_cidr = "10.20.3.0/27"

tags = {
  Environment = "Development"
  Project     = "Azure Databricks"
  Owner       = "DevTeam"
}
