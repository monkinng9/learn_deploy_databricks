# main.tf for storage_mount module

# Create an Azure Storage Container
resource "azurerm_storage_container" "this" {
  name                  = var.storage_container_name
  storage_account_id    = var.storage_account_id
  container_access_type = "private" # Or "blob", "container" depending on needs

  metadata = var.tags
}

# Mount the storage container to Databricks DBFS
# This uses the Azure Storage Account Key stored in Databricks Secrets.
# Ensure the specified cluster (var.databricks_cluster_id) is running during terraform apply.
# Ensure the storage account is ADLS Gen2 enabled (hierarchical namespace) for ABFSS.
resource "databricks_mount" "this" {
  name       = var.databricks_mount_name
  cluster_id = var.databricks_cluster_id
  uri        = "abfss://${azurerm_storage_container.this.name}@${var.storage_account_name}.dfs.core.windows.net/"

  extra_configs = {
    "fs.azure.account.key.${var.storage_account_name}.dfs.core.windows.net" = "{{secrets/${var.databricks_secret_scope}/${var.databricks_secret_key_name}}}"
  }

  # Consider using a Service Principal for enhanced security in production environments.
  # Example for Service Principal (requires different secret setup and variables):
  # extra_configs = {
  #   "fs.azure.account.auth.type.${var.storage_account_name}.dfs.core.windows.net"          = "OAuth"
  #   "fs.azure.account.oauth.provider.type.${var.storage_account_name}.dfs.core.windows.net" = "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider"
  #   "fs.azure.account.oauth2.client.id.${var.storage_account_name}.dfs.core.windows.net"     = "{{secrets/your_scope/your_sp_app_id_key}}"
  #   "fs.azure.account.oauth2.client.secret.${var.storage_account_name}.dfs.core.windows.net" = "{{secrets/your_scope/your_sp_secret_key}}"
  #   "fs.azure.account.oauth2.client.endpoint.${var.storage_account_name}.dfs.core.windows.net" = "https://login.microsoftonline.com/{{secrets/your_scope/your_tenant_id_key}}/oauth2/token"
  # }
}
