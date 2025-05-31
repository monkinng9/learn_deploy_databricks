terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90.0"
    }
  }

  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
