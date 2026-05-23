environment = "dev"

resource_groups = {
  hub = {
    rg_name     = "rg-alime-hub-dev-cindia-001"
    rg_location = "Central India"
    tags = {
      Owner      = "devops"
      Project    = "alime"
      CostCenter = "IT"
    }
  }
  spoke = {
    rg_name     = "rg-alime-spoke-dev-cindia-001"
    rg_location = "Central India"
    tags = {
      Owner      = "devops"
      Project    = "alime"
      CostCenter = "IT"
    }
  }
}

vnets = {
  hub-vnet = {
    vnet_name          = "vnet-alime-hub-dev-cindia-001"
    resource_group_key = "hub"
    location           = "Central India"
    address_space      = ["10.48.0.0/16"]
    tags = {
      Owner      = "devops"
      Project    = "alime"
      CostCenter = "IT"
    }
  }
  spoke-vnet = {
    vnet_name          = "vnet-alime-spoke-dev-cindia-001"
    resource_group_key = "spoke"
    location           = "Central India"
    address_space      = ["10.49.0.0/16"]

    tags = {
      Owner      = "devops"
      Project    = "alime"
      CostCenter = "IT"
    }
  }
}

subnets = {
  azure-firewall-subnet = {
    subnet_name        = "AzureFirewallSubnet"
    resource_group_key = "hub"
    vnet_key           = "hub-vnet"
    address_prefixes   = ["10.48.1.0/24"]
  }
  azure-bastion-subnet = {
    subnet_name        = "AzureBastionSubnet"
    resource_group_key = "hub"
    vnet_key           = "hub-vnet"
    address_prefixes   = ["10.48.2.0/24"]
  }
  agw-subnet = {
    subnet_name        = "snet-agw-dev-cindia-001"
    resource_group_key = "hub"
    vnet_key           = "hub-vnet"
    address_prefixes   = ["10.48.3.0/24"]
  }
  web-subnet = {
    subnet_name        = "snet-web-dev-cindia-001"
    resource_group_key = "spoke"
    vnet_key           = "spoke-vnet"
    address_prefixes   = ["10.49.1.0/24"]
  }
}

peerings = {
  hub-to-spoke = {
    peering_name                 = "peering-hub-to-spoke-dev-cindia-001"
    resource_group_key           = "hub"
    source_vnet_key              = "hub-vnet"
    remote_vnet_key              = "spoke-vnet"
    allow_virtual_network_access = true
    allow_forwarded_traffic      = true
  }
  spoke-to-hub = {
    peering_name                 = "peering-spoke-to-hub-dev-cindia-001"
    resource_group_key           = "spoke"
    source_vnet_key              = "spoke-vnet"
    remote_vnet_key              = "hub-vnet"
    allow_virtual_network_access = true
    allow_forwarded_traffic      = true
  }
}

nsgs = {
  web-nsg = {
    nsg_name           = "nsg-web-dev-cindia-001"
    resource_group_key = "spoke"
    subnet_key         = "web-subnet"
    location           = "Central India"
    security_rules = {
      allow-http-from-firewall = {
        name                       = "allow-http-from-firewall"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "10.48.1.0/24"
        destination_address_prefix = "*"
      }
      allow-rdp-from-firewall = {
        name                       = "allow-rdp-from-firewall"
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = "10.48.1.0/24"
        destination_address_prefix = "*"
      }
      allow-http-from-agw = {
        name                       = "allow-http-from-agw"
        priority                   = 105
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "10.48.3.0/24"
        destination_address_prefix = "*"
      }
    }
  }
}

nics = {
  web = {
    nic_name                      = "nic-web-dev-cindia-001"
    location                      = "Central India"
    resource_group_key            = "spoke"
    subnet_key                    = "web-subnet"
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.49.1.10"
    tags = {
      role = "web"
    }
  }
}

windows_vms = {
  web = {
    vm_name            = "vm-web-dev-cindia-001"
    computer_name      = "webdev01"
    location           = "Central India"
    resource_group_key = "spoke"
    nic_keys = [
      "web"
    ]
    size = "Standard_B2als_v2"
    os_disk = {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
    source_image_reference = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2022-datacenter-azure-edition"
      version   = "latest"
    }
    tags = {
      role = "web"
    }
  }
}

vm_extensions = {
  web-iis = {
    extension_name             = "ext-iis-web-dev-cindia-001"
    vm_key                     = "web"
    publisher                  = "Microsoft.Compute"
    type                       = "CustomScriptExtension"
    type_handler_version       = "1.10"
    auto_upgrade_minor_version = true
    settings                   = <<SETTINGS
{
  "commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted -Command \"Install-WindowsFeature -Name Web-Server -IncludeManagementTools; Set-Content -Path 'C:\\\\inetpub\\\\wwwroot\\\\index.html' -Value '<h1>Welcome to Alime Web Server</h1>'\""
}
SETTINGS
  }
}

firewalls = {
  hub = {
    firewall_name      = "fw-hub-dev-cindia-001"
    public_ip_name     = "pip-fw-hub-dev-cindia-001"
    location           = "Central India"
    resource_group_key = "hub"
    subnet_key         = "azure-firewall-subnet"
    sku_tier           = "Standard"
    tags = {
      role = "firewall"
    }
  }
}

firewall_nat_rules = {
  rdp = {
    firewall_key       = "hub"
    resource_group_key = "hub"
    name               = "rcg-dnat-rdp-dev-cindia-001"
    priority           = 100
    action             = "Dnat"
    rules = [
      {
        name = "dnat-rdp"
        source_addresses = [
          "49.204.16.78"
        ]
        destination_ports = [
          "3389"
        ]
        translated_address = "10.49.1.10"
        translated_port    = "3389"
        protocols = [
          "TCP"
        ]
      }
    ]
  }
}

firewall_network_rules = {
  agw = {
    firewall_key       = "hub"
    resource_group_key = "hub"
    name               = "rcg-agw-network-dev-cindia-001"
    priority           = 100
    action             = "Allow"
    rules = [
      {
        name = "allow-agw-to-vm-http"
        source_addresses = [
          "10.48.3.0/24"
        ]
        destination_addresses = [
          "10.49.1.10"
        ]
        destination_ports = [
          "80"
        ]
        protocols = [
          "TCP"
        ]
      }
    ]
  }
}

firewall_application_rules = {

  block-google = {
    firewall_key       = "hub"
    resource_group_key = "hub"
    name               = "rcg-block-google-dev-cindia-001"
    priority           = 100
    action             = "Deny"
    rules = [
      {
        name = "deny-google"
        source_addresses = [
          "10.49.1.0/24"
        ]
        target_fqdns = [
          "google.com",
          "*.google.com"
        ]
        protocols = [
          {
            type = "Http"
            port = 80
          },
          {
            type = "Https"
            port = 443
          }
        ]
      }
    ]
  }

  allow-internet = {
    firewall_key       = "hub"
    resource_group_key = "hub"
    name               = "rcg-allow-internet-dev-cindia-001"
    priority           = 200
    action             = "Allow"
    rules = [
      {
        name = "allow-general-internet"
        source_addresses = [
          "10.49.1.0/24"
        ]
        target_fqdns = [
          "*"
        ]
        protocols = [
          {
            type = "Http"
            port = 80
          },
          {
            type = "Https"
            port = 443
          }
        ]
      }
    ]
  }

  allow-windows-update = {
    firewall_key       = "hub"
    resource_group_key = "hub"
    name               = "rcg-app-dev-cindia-001"
    priority           = 300
    action             = "Allow"
    rules = [
      {
        name = "allow-windows-update"
        source_addresses = [
          "10.49.1.0/24"
        ]
        target_fqdns = [
          "*.windowsupdate.com",
          "*.update.microsoft.com"
        ]
        protocols = [
          {
            type = "Http"
            port = 80
          },
          {
            type = "Https"
            port = 443
          }
        ]
      }
    ]
  }
}

route_tables = {

  spoke-web = {
    route_table_name   = "rt-web-dev-cindia-001"
    location           = "Central India"
    resource_group_key = "spoke"
    routes = [
      {
        name           = "default-egress-via-firewall"
        address_prefix = "0.0.0.0/0"
        next_hop_type  = "VirtualAppliance"
      },

      {
        name           = "agw-return-via-firewall"
        address_prefix = "10.48.3.0/24"
        next_hop_type  = "VirtualAppliance"
      }
    ]
    tags = {
      role = "web-routing"
    }
  }

  agw = {
    route_table_name   = "rt-agw-dev-cindia-001"
    location           = "Central India"
    resource_group_key = "hub"
    routes = [
      {
        name           = "allow-inbound-traffic-to-websnet-via-fw"
        address_prefix = "10.49.1.0/24"
        next_hop_type  = "VirtualAppliance"
      }
    ]
    tags = {
      role = "agw-routing"
    }
  }
}

route_table_associations = {

  web = {
    subnet_key      = "web-subnet"
    route_table_key = "spoke-web"
  }

  agw = {
    subnet_key      = "agw-subnet"
    route_table_key = "agw"
  }
}

application_gateways = {
  agw = {
    application_gateway_name = "agw-dev-cindia-001"
    public_ip_name           = "pip-agw-dev-cindia-001"
    location                 = "Central India"
    resource_group_key       = "hub"
    subnet_key               = "agw-subnet"
    sku_name                 = "Standard_v2"
    sku_tier                 = "Standard_v2"
    capacity                 = 1
    backend_pool_name        = "be-web-dev-cindia-001"
    backend_vm_private_ips = [
      "10.49.1.10"
    ]
    frontend_port_name = "fp-http"
    frontend_port      = 80
    http_setting_name  = "bhs-http"
    listener_name      = "listener-http"
    routing_rule_name  = "rule-http"
    probe_name         = "probe-http"
    probe_host         = "localhost"
    probe_path         = "/"
    tags = {
      role = "application-gateway"
    }
  }
}

log_analytics_workspaces = {
  common = {
    workspace_name     = "law-alime-dev-cindia-001"
    location           = "Central India"
    resource_group_key = "hub"
    retention_in_days  = 30
    tags = {
      role = "monitoring"
    }
  }
}

diagnostic_settings = {

  firewall = {
    diagnostic_name = "diag-fw-dev-cindia-001"
    resource_type   = "firewall"
    resource_key    = "hub"
    workspace_key   = "common"
  }

  agw = {
    diagnostic_name = "diag-agw-dev-cindia-001"
    resource_type   = "agw"
    resource_key    = "agw"
    workspace_key   = "common"
  }
}
