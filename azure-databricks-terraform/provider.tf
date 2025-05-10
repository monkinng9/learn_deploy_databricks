terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.75" # Use a recent version
    }
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.27" # Use a recent version
    }
  }
}

provider "azurerm" {
  features {}
}

# Provider for Databricks specific resources (Metastore, assignments)
# This will be configured after the workspace is created,
# typically using the workspace URL and a PAT token or AAD authentication.
# For initial setup and metastore creation tied to workspace, we might rely on azurerm only initially
# and configure databricks provider for subsequent management if needed.
# For Unity Catalog setup, `azurerm_databricks_metastore` and `azurerm_databricks_workspace_root_dbfs_customer_managed_key`
# do not require the databricks provider directly for their creation.
# `azurerm_databricks_metastore_assignment` links them.