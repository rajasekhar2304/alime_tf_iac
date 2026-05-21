resource "azurerm_windows_virtual_machine" "vm" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  size                  = var.size
  network_interface_ids = var.network_interface_ids
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  provision_vm_agent    = true
  os_disk {
    caching              = var.os_disk.caching
    storage_account_type = var.os_disk.storage_account_type
  }
  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }
  tags = var.tags
  lifecycle {
    ignore_changes = [
      admin_password
    ]
  }
}
