locals {
  server_username = "postgresql"
  server_password = "password123!"
  database_name   = "api-psqldatabase"
}

resource "azurerm_postgresql_server" "server" {
  name                = "api-psqlserver"
  location            = azurerm_resource_group.primary.location
  resource_group_name = azurerm_resource_group.primary.name

  administrator_login          = local.server_username
  administrator_login_password = local.server_password

  sku_name   = "GP_Gen5_4"
  version    = "9.6"
  storage_mb = 640000

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = false

  public_network_access_enabled    = true
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
}

resource "azurerm_postgresql_database" "db" {
  name                = local.database_name
  resource_group_name = azurerm_resource_group.primary.name
  server_name         = azurerm_postgresql_server.server.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

resource "azurerm_linux_web_app" "api" {
  name                = "payroll-challenge-api"
  resource_group_name = azurerm_resource_group.primary.name
  location            = azurerm_resource_group.primary.location
  service_plan_id     = azurerm_service_plan.primary.id

  site_config {
    always_on = true
    application_stack {
      docker_image     = "${azurerm_container_registry.registry.login_server}/api"
      docker_image_tag = "latest"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "FrontendOrigin"                     = "http://localhost:3000"
    "ConnectionStrings__EmployeeContext" = "Host=${azurerm_postgresql_server.server.fqdn};Port=5432;Database=${local.database_name};Username=${local.server_username};Password=${local.server_password}"
  }
}

