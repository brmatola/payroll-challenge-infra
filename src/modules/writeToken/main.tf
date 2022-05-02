resource "azurerm_container_registry_scope_map" "map" {
  name                    = var.name
  container_registry_name = var.container_registry_name
  resource_group_name     = var.resource_group_name
  actions = [
    "repositories/${var.repository_name}/content/write",
    "repositories/${var.repository_name}/content/read"
  ]
}

resource "azurerm_container_registry_token" "write_api" {
  name                    = var.name
  container_registry_name = var.container_registry_name
  resource_group_name     = var.resource_group_name
  scope_map_id            = azurerm_container_registry_scope_map.map.id
  enabled                 = true
}
