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
    }
  }
}