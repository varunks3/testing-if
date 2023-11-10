variable "vm_name" {
  type        = string
  default = "jiravm2"
}
variable "vm_size" {
  type = string
  default = "Standard_DS1_v2"
}

variable "resource_group_name" {
  type        = string
  default     = "Jira-azure"
}

variable "resource_group_location" {
  type        = string
  default     = "West Europe"
}

variable "availability_zone" {
  type        = number
  default     = 1
}

variable "image" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
