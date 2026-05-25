output "resource_group_names" {
  value = {
    for k, rg in module.resource_groups :
    k => rg.resource_group_name
  }
}

output "vnet_names" {
  value = {
    for k, vnet in module.vnets :
    k => vnet.vnet_name
  }
}

output "subnet_names" {
  value = {
    for k, subnet in module.subnets :
    k => subnet.subnet_name
  }
}

output "nsg_names" {
  value = {
    for k, nsg in module.nsgs :
    k => nsg.nsg_name
  }
}

output "vm_names" {
  value = {
    for k, vm in module.windows_vms :
    k => vm.vm_name
  }
}