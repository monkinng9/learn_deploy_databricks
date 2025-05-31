# outputs.tf for storage_mount module

output "dbfs_mount_path" {
  description = "The full DBFS path where the container is mounted."
  value       = "/mnt/${databricks_mount.this.name}"
}

output "storage_container_id" {
  description = "The ID of the created Azure Storage Container."
  value       = azurerm_storage_container.this.id
}

output "storage_container_name" {
  description = "The name of the created Azure Storage Container."
  value       = azurerm_storage_container.this.name
}
