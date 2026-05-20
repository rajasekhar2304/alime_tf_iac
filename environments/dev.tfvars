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