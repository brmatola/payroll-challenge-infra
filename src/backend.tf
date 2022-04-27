terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }

  backend "azurerm" {
      resource_group_name = "paylocity-code-challenge"
      storage_account_name = ""
      container_name = "tfstate"
      key = ""
  }
}

provider "azurerm" {
  features {}
}
