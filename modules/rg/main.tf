resource "azurerm_resource_group" "rg" {
  name = var.rg_name
  location = var.rg_location

  tags = merge(
    var.common_tags,
    var.tags
  )
}