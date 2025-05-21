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
  adls_storage_account_name = "${var.prefix}${var.adls_storage_account_name_suffix}"
}
