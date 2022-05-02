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

resource "azurerm_container_registry_scope_map" "write_api" {
  name                    = "write-api"
  container_registry_name = azurerm_container_registry.registry.name
  resource_group_name     = azurerm_resource_group.primary.name
  actions                 = ["repositories/api/content/write"]
}

resource "azurerm_container_registry_token" "write_api" {
  name                    = "write-api"
  container_registry_name = azurerm_container_registry.registry.name
  resource_group_name     = azurerm_resource_group.primary.name
  scope_map_id            = azurerm_container_registry_scope_map.write_api.id
}
