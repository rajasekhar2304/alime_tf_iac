resource "azurerm_public_ip" "agw_pip" {
  name = var.public_ip_name
  location = var.location
  resource_group_name = var.resource_group_name
  allocation_method = "Static"
  sku = "Standard"
  tags = var.tags
}

resource "azurerm_application_gateway" "agw" {
  name = var.application_gateway_name
  location = var.location
  resource_group_name = var.resource_group_name
  sku {
    name = var.sku_name
    tier = var.sku_tier
    capacity = var.capacity
  }
  gateway_ip_configuration {
    name = "gateway-ip-config"
    subnet_id = var.subnet_id
  }
  frontend_port {
    name = var.frontend_port_name
    port = var.frontend_port
  }
  frontend_ip_configuration {
    name = "frontend-ip-config"
    public_ip_address_id = azurerm_public_ip.agw_pip.id
  }
  backend_address_pool {
    name = var.backend_pool_name
    ip_addresses = var.backend_ip_addresses
  }
  backend_http_settings {
    name = var.http_setting_name
    cookie_based_affinity = "Disabled"
    path = "/"
    port = 80
    protocol = "Http"
    request_timeout = 30
    probe_name = var.probe_name
  }
  probe {
    name = var.probe_name
    protocol = "Http"
    path = var.probe_path
    host = var.probe_host
    interval = 30
    timeout = 30
    unhealthy_threshold = 3
    pick_host_name_from_backend_http_settings = false
  }

  http_listener {
    name = var.listener_name
    frontend_ip_configuration_name = "frontend-ip-config"
    frontend_port_name = var.frontend_port_name
    protocol = "Http"
  }
  request_routing_rule {
    name = var.routing_rule_name
    rule_type = "Basic"
    http_listener_name = var.listener_name
    backend_address_pool_name = var.backend_pool_name
    backend_http_settings_name = var.http_setting_name
    priority = 100
  }
  tags = var.tags
}