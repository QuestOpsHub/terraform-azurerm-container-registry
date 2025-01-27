#---------------
# Random String
#---------------
module "random_string" {
  source = "git::https://github.com/QuestOpsHub/terraform-azurerm-random-string.git?ref=v1.0.0"

  length  = 4
  lower   = true
  numeric = true
  special = false
  upper   = false
}

#----------------
# Resource Group
#----------------
module "resource_group" {
  source = "git::https://github.com/QuestOpsHub/terraform-azurerm-resource-group.git?ref=v1.0.0"

  name     = "rg-${local.resource_suffix}-${module.random_string.result}"
  location = "centralus"
  tags     = merge(local.resource_tags, local.timestamp_tag)
}

#------------------------
# User Assigned Identity
#------------------------
module "user_assigned_identity" {
  source = "git::https://github.com/QuestOpsHub/terraform-azurerm-user-assigned-identity.git?ref=v1.0.0"

  name                = "id-${local.resource_suffix}-${module.random_string.result}"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  tags                = merge(local.resource_tags, local.timestamp_tag)
}

#--------------------
# Container Registry
#--------------------
module "container_registry" {
  source = "git::https://github.com/QuestOpsHub/terraform-azurerm-container-registry.git?ref=v1.0.0"

  name                = replace("acr-${local.resource_suffix}-${module.random_string.result}", "/[[:^alnum:]]/", "")
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  sku                 = "Standard"
  identity = {
    type         = "UserAssigned"
    identity_ids = [module.user_assigned_identity.id]
  }
  tags = merge(local.resource_tags, local.timestamp_tag)
}