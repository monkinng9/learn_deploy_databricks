output "resource_group_name" {
  description = "Name of the resource group."
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Location of the resource group."
  value       = azurerm_resource_group.main.location
}

output "databricks_workspace_url" {
  description = "URL of the deployed Azure Databricks workspace."
  value       = module.databricks.databricks_workspace_url
}

output "databricks_workspace_id" {
  description = "ID of the deployed Azure Databricks workspace."
  value       = module.databricks.databricks_workspace_id
}

output "databricks_managed_resource_group_id" {
  description = "ID of the managed resource group created by Azure Databricks."
  value       = module.databricks.databricks_managed_resource_group_id
}

output "virtual_network_name" {
  description = "Name of the deployed Virtual Network."
  value       = module.vnet.virtual_network_name
}

output "virtual_network_id" {
  description = "ID of the deployed Virtual Network."
  value       = module.vnet.virtual_network_id
}

output "network_security_group_name" {
  description = "Name of the deployed Network Security Group."
  value       = module.vnet.network_security_group_name
}

output "network_security_group_id" {
  description = "ID of the deployed Network Security Group."
  value       = module.vnet.network_security_group_id
}

output "private_endpoint_name" {
  description = "Name of the deployed Private Endpoint for Databricks."
  value       = module.databricks.private_endpoint_name
}

output "private_endpoint_id" {
  description = "ID of the deployed Private Endpoint for Databricks."
  value       = module.databricks.private_endpoint_id
}

output "private_dns_zone_name" {
  description = "Name of the Private DNS Zone for Databricks."
  value       = module.databricks.private_dns_zone_name
}

output "private_dns_zone_id" {
  description = "ID of the Private DNS Zone for Databricks."
  value       = module.databricks.private_dns_zone_id
}

output "adls_storage_account_name" {
  description = "Name of the deployed ADLS Gen2 storage account."
  value       = module.storage.adls_storage_account_name
}

output "adls_storage_account_id" {
  description = "ID of the deployed ADLS Gen2 storage account."
  value       = module.storage.adls_storage_account_id
}

output "adls_storage_account_primary_dfs_endpoint" {
  description = "The primary DFS (Data Lake) endpoint for the ADLS Gen2 storage account."
  value       = module.storage.adls_storage_account_primary_dfs_endpoint
}
