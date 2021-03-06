resource "azurerm_linux_web_app" "frontend" {
  name                = "payroll-challenge-frontend"
  resource_group_name = azurerm_resource_group.primary.name
  location            = azurerm_resource_group.primary.location
  service_plan_id     = azurerm_service_plan.primary.id

  site_config {
    always_on                               = true
    container_registry_use_managed_identity = true
    application_stack {
      docker_image     = "${azurerm_container_registry.registry.login_server}/frontend"
      docker_image_tag = "latest"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "DOCKER_ENABLE_CI"           = "true"
    "DOCKER_REGISTRY_SERVER_URL" = "https://${azurerm_container_registry.registry.login_server}"
    "BACKEND_URL"                = "https://payroll-challenge-api.azurewebsites.net"
  }
}


resource "azurerm_role_assignment" "frontend_pull" {
  principal_id         = azurerm_linux_web_app.frontend.identity.0.principal_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.registry.id
}

resource "azurerm_container_registry_webhook" "frontend" {
  name                = "frontend"
  resource_group_name = azurerm_resource_group.primary.name
  registry_name       = azurerm_container_registry.registry.name
  location            = azurerm_resource_group.primary.location
  service_uri         = "https://${azurerm_linux_web_app.frontend.site_credential[0].name}:${azurerm_linux_web_app.frontend.site_credential[0].password}@${azurerm_linux_web_app.frontend.name}.scm.azurewebsites.net/docker/hook"
  status              = "enabled"
  scope               = "frontend"
  actions             = ["push"]
  custom_headers = {
    "Content-Type" = "application/json"
  }
}
