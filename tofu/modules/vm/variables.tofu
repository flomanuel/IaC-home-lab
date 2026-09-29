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

variable "data_disks" {
  description = "Additional disks, attached as scsi1, scsi2, ... in list order, e.g. [{ datastore_id = \"local-zfs\", size = 8, serial = \"k3s-etcd\" }]. Size in GiB. The serial is visible in the guest via `lsblk -o NAME,SERIAL`. Leave empty (the default) for none."
  type = list(object({
    datastore_id = string
    size         = number
    serial       = string
    backup       = optional(bool, true)
  }))
  default = []

  validation {
    condition     = alltrue([for d in var.data_disks : length(d.serial) <= 20])
    error_message = "A data disk serial must be at most 20 characters long."
  }
}

variable "machine" {
  description = "QEMU machine type: pc (i440fx) or q35. PCIe passthrough (pci_devices with pcie = true) needs q35. Changing it on an existing VM reboots it. null keeps the Proxmox default (pc) without touching existing VMs."
  type        = string
  default     = null
}

variable "pci_devices" { # see the runbook in docs for needed os config
  description = "Host PCI devices passed through as hostpci0, hostpci1, ... in list order, by the name of a Proxmox Resource Mapping (Datacenter -> Resource Mappings; the API token cannot use raw PCI ids). Leave empty (the default) for none."
  type = list(object({
    mapping = string
    pcie    = optional(bool, true)
    rombar  = optional(bool, true)
  }))
  default = []

  validation {
    condition     = alltrue([for d in var.pci_devices : !d.pcie || startswith(coalesce(var.machine, "pc"), "q35")])
    error_message = "pcie = true requires machine = \"q35\"."
  }
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

variable "create_after" {
  description = "Upstream module(s) (e.g. [module.debian-01]) this VM's disk creation must wait for."
  type        = any
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
