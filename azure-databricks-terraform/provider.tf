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
