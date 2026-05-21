data "azurerm_key_vault" "kv" {
  name                = "alime-kv"
  resource_group_name = "Terraform-RG"
}

data "azurerm_key_vault_secret" "vm_admin_username" {
  name         = "vm-admin-username"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "vm_admin_password" {
  name         = "vm-admin-password"
  key_vault_id = data.azurerm_key_vault.kv.id
}