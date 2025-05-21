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

output "private_endpoint_id" {
  description = "ID of the deployed Private Endpoint for Databricks."
  value       = var.create_private_endpoint ? azurerm_private_endpoint.main[0].id : null
}

output "private_endpoint_name" {
  description = "Name of the deployed Private Endpoint for Databricks."
  value       = var.create_private_endpoint ? azurerm_private_endpoint.main[0].name : null
}

output "private_dns_zone_id" {
  description = "ID of the Private DNS Zone for Databricks."
  value       = var.create_private_endpoint ? azurerm_private_dns_zone.main[0].id : null
}

output "private_dns_zone_name" {
  description = "Name of the Private DNS Zone for Databricks."
  value       = var.create_private_endpoint ? azurerm_private_dns_zone.main[0].name : null
}
