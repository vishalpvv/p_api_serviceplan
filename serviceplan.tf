resource "azurerm_app_service_plan" "web_app_service_plan" {
  name                = "${var.environment_prefix}-${local.location_prefix}-p-api-regsub-web-app-service-plan01"
  location            = local.location
  resource_group_name = local.services_resource_group_name
  kind                = "Linux"
  reserved            = true
  zone_redundant      = local.zone_redundant

  sku {
    tier     = local.web_app_sku.tier
    size     = local.web_app_sku.size
    capacity = local.web_app_sku.capacity
  }
  
}


