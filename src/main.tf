resource "azurerm_resource_group" "primary" {
  name     = "paylocity-challenge"
  location = "eastus"
}

resource "azurerm_container_registry" "registry" {
  name                = "paylocityChallengeRegistry"
  resource_group_name = azurerm_resource_group.primary.name
  location            = azurerm_resource_group.primary.location
  sku                 = "Premium"
}

module "api_acr_write_token" {
  source = "./modules/writeToken"

  name                    = "write-api"
  repository_name         = "api"
  container_registry_name = azurerm_container_registry.registry.name
  resource_group_name     = azurerm_resource_group.primary.name
}

module "frontend_acr_write_token" {
  source = "./modules/writeToken"

  name                    = "write-frontend"
  repository_name         = "frontend"
  container_registry_name = azurerm_container_registry.registry.name
  resource_group_name     = azurerm_resource_group.primary.name
}

resource "azurerm_service_plan" "primary" {
  name                = "primary"
  resource_group_name = azurerm_resource_group.primary.name
  location            = azurerm_resource_group.primary.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}
