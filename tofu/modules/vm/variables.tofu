variable "common" {
  description = "Shared settings from the root module (pass local.common)."
  type = object({
    node_name       = string
    trunk_bridge    = string
    storage_disks   = string
    vlans           = map(object({ tag = number, cidr = string, gateway = string }))
    images          = map(string)
    snippets        = map(string)
    vm_user         = string
    ssh_public_keys = list(string)
    dns_servers     = list(string)
    dns_domain      = string
    security_groups = map(string)
  })
}

variable "name" {
  description = "VM name (also becomes the cloud-init hostname)."
  type        = string
}

variable "image" {
  description = "Base image key from common.images: debian | ubuntu."
  type        = string
}

variable "snippet" {
  description = "Snippet key from common.images: qemu_base_image_debian"
  type        = string
}

variable "networks" {
  description = "NICs on the trunk bridge. The FIRST entry is the primary NIC and gets the default gateway; further entries (e.g. a data-VLAN NIC for NFS) get none."
  type = list(object({
    vlan = string # key into common.vlans
    ip   = string # CIDR, e.g. "10.50.1.10/16"
  }))

  validation {
    condition     = length(var.networks) > 0
    error_message = "At least one network is required."
  }
}

variable "cores" {
  type    = number
  default = 2
}

variable "memory" {
  description = "RAM in MiB."
  type        = number
  default     = 2048
}

variable "disk_gb" {
  type    = number
  default = 20
}

variable "vm_id" {
  description = "Fixed VMID; null lets Proxmox pick one."
  type        = number
  default     = null
}

variable "tags" {
  type    = list(string)
  default = []
}

variable "start_on_boot" {
  type    = bool
  default = true
}

variable "agent_enabled" {
  description = "Cloud images ship without qemu-guest-agent, and with this true the provider waits for the agent on apply. Leave false for the first apply; optionally flip to true after the Ansible base role installed the agent."
  type        = bool
  default     = false
}

variable "global_security_groups" {
  description = "Keys into common.security_groups (the shared groups defined once in the root module's firewall.tf) to attach to this VM's firewall, e.g. [\"ssh\", \"http\", \"https\"]. Leave empty (the default) to attach none."
  type        = list(string)
  default     = []
}

variable "custom_firewall_rules" {
  description = "This VM's own one-off firewall rules, grouped under a label for readability, e.g. { nfs4 = [{ type = \"in\", action = \"ACCEPT\", proto = \"tcp\", dport = \"2049\", comment = \"NFSv4\", iface = \"net1\" }] }. The label is not a Proxmox object; these become direct rules on this VM's firewall, not a security group. Leave empty (the default) to define none."
  type = map(list(object({
    type    = string
    action  = string
    proto   = optional(string)
    dport   = optional(string)
    sport   = optional(string)
    source  = optional(string)
    dest    = optional(string)
    comment = optional(string)
    iface   = optional(string)
  })))
  default = {}
}
