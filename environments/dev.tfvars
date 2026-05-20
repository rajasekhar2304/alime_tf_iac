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