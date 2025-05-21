output "databricks_workspace_url" {
  description = "URL of the deployed Azure Databricks workspace."
  value       = azurerm_databricks_workspace.main.workspace_url
}

output "databricks_workspace_id" {
  description = "ID of the deployed Azure Databricks workspace."
  value       = azurerm_databricks_workspace.main.id
}

output "databricks_managed_resource_group_id" {
  description = "ID of the managed resource group created by Azure Databricks."
  value       = azurerm_databricks_workspace.main.managed_resource_group_id
}

output "virtual_network_name" {
  description = "Name of the deployed Virtual Network."
  value       = azurerm_virtual_network.main.name
}

output "virtual_network_id" {
  description = "ID of the deployed Virtual Network."
  value       = azurerm_virtual_network.main.id
}

output "network_security_group_name" {
  description = "Name of the deployed Network Security Group."
  value       = azurerm_network_security_group.main.name
}

output "network_security_group_id" {
  description = "ID of the deployed Network Security Group."
  value       = azurerm_network_security_group.main.id
}

output "private_endpoint_name" {
  description = "Name of the deployed Private Endpoint for Databricks."
  value       = azurerm_private_endpoint.main.name
}

output "private_endpoint_id" {
  description = "ID of the deployed Private Endpoint for Databricks."
  value       = azurerm_private_endpoint.main.id
}

output "private_dns_zone_name" {
  description = "Name of the Private DNS Zone for Databricks."
  value       = azurerm_private_dns_zone.main.name
}

output "private_dns_zone_id" {
  description = "ID of the Private DNS Zone for Databricks."
  value       = azurerm_private_dns_zone.main.id
}
