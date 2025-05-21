output "adls_storage_account_name" {
  description = "Name of the deployed ADLS Gen2 storage account."
  value       = azurerm_storage_account.adls.name
}

output "adls_storage_account_id" {
  description = "ID of the deployed ADLS Gen2 storage account."
  value       = azurerm_storage_account.adls.id
}

output "adls_storage_account_primary_dfs_endpoint" {
  description = "The primary DFS (Data Lake) endpoint for the ADLS Gen2 storage account."
  value       = azurerm_storage_account.adls.primary_dfs_endpoint
}
