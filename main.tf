module "resource_groups" {
  source      = "./modules/rg"
  for_each    = var.resource_groups
  rg_name     = each.value.rg_name
  rg_location = each.value.rg_location
  tags        = merge(
    local.common_tags,
    each.value.tags
  )
}