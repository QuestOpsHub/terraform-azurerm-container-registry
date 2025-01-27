#--------------------
# Container Registry
#--------------------
resource "azurerm_container_registry" "container_registry" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = try(var.admin_enabled, false)

  dynamic "georeplications" {
    for_each = var.sku == "Premium" && length(keys(try(var.georeplications, {}))) > 0 ? try(var.georeplications, {}) : {}
    content {
      location                  = georeplications.value.location
      regional_endpoint_enabled = lookup(georeplications.value, "regional_endpoint_enabled", null)
      zone_redundancy_enabled   = lookup(georeplications.value, "zone_redundancy_enabled", false)
      tags                      = lookup(georeplications.value, "tags", {})
    }
  }

  dynamic "network_rule_set" {
    for_each = var.sku == "Premium" && try(var.network_rule_set, {}) != {} ? [var.network_rule_set] : []
    content {
      default_action = lookup(network_rule_set.value, "default_action", "Allow")
      dynamic "ip_rule" {
        for_each = length(keys(lookup(network_rule_set.value, "ip_rule", {}))) > 0 ? lookup(network_rule_set.value, "ip_rule", {}) : {}
        content {
          action   = ip_rule.value.action
          ip_range = ip_rule.value.ip_range
        }
      }
    }
  }

  public_network_access_enabled = try(var.public_network_access_enabled, true)
  quarantine_policy_enabled     = try(var.quarantine_policy_enabled, null)

  retention_policy_in_days = var.sku == "Premium" ? try(var.retention_policy_in_days, 7) : null
  trust_policy_enabled     = try(var.trust_policy_enabled, false)
  zone_redundancy_enabled  = try(var.zone_redundancy_enabled, false)
  export_policy_enabled    = try(var.export_policy_enabled, true)

  dynamic "identity" {
    for_each = try(var.identity.type, null) != null ? [var.identity.type] : []
    content {
      type         = var.identity.type
      identity_ids = var.identity.type == "UserAssigned" || var.identity.type == "SystemAssigned, UserAssigned" ? var.identity.identity_ids : null
    }
  }

  dynamic "encryption" {
    for_each = try(var.encryption, {}) != {} ? [var.encryption] : []
    content {
      key_vault_key_id   = encryption.value.key_vault_key_id
      identity_client_id = encryption.value.identity_client_id
    }
  }

  anonymous_pull_enabled     = contains(["Standard", "Premium"], var.sku) ? try(var.anonymous_pull_enabled, null) : null
  data_endpoint_enabled      = var.sku == "Premium" ? try(var.data_endpoint_enabled, null) : null
  network_rule_bypass_option = try(var.network_rule_bypass_option, "AzureServices")

  tags = var.tags
  lifecycle {
    ignore_changes = [
      tags["creation_timestamp"],
    ]
  }
}