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
