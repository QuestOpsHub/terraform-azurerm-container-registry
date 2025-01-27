#--------------------
# Container Registry
#--------------------
variable "name" {
  description = "(Required) Specifies the name of the Container Registry. Only Alphanumeric characters allowed. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Container Registry. Changing this forces a new resource to be created."
  type        = string
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
}

variable "sku" {
  description = "va(Required) The SKU name of the container registry. Possible values are Basic, Standard and Premium.lue"
  type        = string
}

variable "admin_enabled" {
  description = "(Optional) Specifies whether the admin user is enabled. Defaults to false."
  type        = string
  default     = false
}

variable "georeplications" {
  description = "(Optional) One or more georeplications blocks"
  type        = any
  default     = {}
}

variable "network_rule_set" {
  description = "(Optional) A network_rule_set block"
  type        = any
  default     = {}
}

variable "public_network_access_enabled" {
  description = "(Optional) Whether public network access is allowed for the container registry. Defaults to true."
  type        = bool
  default     = true
}

variable "quarantine_policy_enabled" {
  description = "(Optional) Boolean value that indicates whether quarantine policy is enabled."
  type        = bool
  default     = null
}

variable "retention_policy_in_days" {
  description = "(Optional) The number of days to retain and untagged manifest after which it gets purged. Defaults to 7."
  type        = number
  default     = 7
}

variable "trust_policy_enabled" {
  description = "(Optional) Boolean value that indicated whether trust policy is enabled. Defaults to false."
  type        = bool
  default     = false
}

variable "zone_redundancy_enabled" {
  description = "(Optional) Whether zone redundancy is enabled for this Container Registry? Changing this forces a new resource to be created. Defaults to false."
  type        = bool
  default     = false
}

variable "export_policy_enabled" {
  description = "(Optional) Boolean value that indicates whether export policy is enabled. Defaults to true. In order to set it to false, make sure the public_network_access_enabled is also set to false."
  type        = bool
  default     = true
}

variable "identity" {
  description = "(Optional) An identity block"
  type        = any
  default     = {}
}

variable "encryption" {
  description = "(Optional) An encryption block"
  type        = any
  default     = {}
}

variable "anonymous_pull_enabled" {
  description = "(Optional) Whether allows anonymous (unauthenticated) pull access to this Container Registry? This is only supported on resources with the Standard or Premium SKU."
  type        = bool
  default     = null
}

variable "data_endpoint_enabled" {
  description = "(Optional) Whether to enable dedicated data endpoints for this Container Registry? This is only supported on resources with the Premium SKU."
  type        = bool
  default     = null
}

variable "network_rule_bypass_option" {
  description = "(Optional) Whether to allow trusted Azure services to access a network restricted Container Registry? Possible values are None and AzureServices. Defaults to AzureServices."
  type        = string
  default     = "AzureServices"
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(any)
  default     = {}
}