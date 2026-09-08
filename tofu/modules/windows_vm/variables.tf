variable "common" {
  description = "Shared settings from the root module (pass local.common)."
  type = object({
    node_name       = string
    trunk_bridge    = string
    storage_disks   = string
    vlans           = map(object({ tag = number, cidr = string, gateway = string }))
    images          = map(string)
    vm_user         = string
    ssh_public_keys = list(string)
    dns_servers     = list(string)
  })
}

variable "name" {
  type = string
}

variable "template_vm_id" {
  description = "VMID of the hand-built Windows template (docs/runbooks/windows-template.md). Disk size is inherited from the template; grow it in the Proxmox UI if needed."
  type        = number
}

variable "networks" {
  description = "NICs on the trunk bridge. IP configuration happens inside Windows (hand-managed)."
  type = list(object({
    vlan = string # key into common.vlans
  }))
}

variable "cores" {
  type    = number
  default = 4
}

variable "memory" {
  description = "RAM in MiB."
  type        = number
  default     = 8192
}

variable "vm_id" {
  type    = number
  default = null
}

variable "tags" {
  type    = list(string)
  default = []
}

variable "start_on_boot" {
  type    = bool
  default = true
}
