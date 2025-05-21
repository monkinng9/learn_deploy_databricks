resource "azurerm_storage_account" "adls" {
  name                     = local.adls_storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = true
  min_tls_version          = "TLS1_2"
  # Note: allow_blob_public_access is deprecated and now controlled by
  # the blob_properties.container_delete_retention_policy block
  blob_properties {
    delete_retention_policy {
      days = 7
    }
    container_delete_retention_policy {
      days = 7
    }
  }
  tags                     = var.tags
}

locals {
  # Storage account names must be between 3 and 24 characters in length and may contain numbers and lowercase letters only
  # Remove any hyphens and ensure the name is lowercase
  adls_storage_account_name = lower(replace("${var.prefix}${var.adls_storage_account_name_suffix}", "-", ""))
}
