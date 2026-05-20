module "resource_groups" {
  source = "./modules/rg"
  for_each = var.resource_groups
  rg_name     = each.value.rg_name
  rg_location = each.value.rg_location
  tags = each.value.tags
  common_tags = local.common_tags
}