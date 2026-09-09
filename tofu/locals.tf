/**
https://opentofu.org/docs/language/values/locals/
Compare modules to function definitions:
- Input variables are like function arguments.
- Output values are like function return values.
- Local values are like a function's temporary local variables.
*/

locals {
  # The VLANs available on the trunk bridge. A VM joins a VLAN by listing it
  # in its `networks` — that (plus OPNsense rules) is the access control.
  vlans = {
    mgmt = { tag = 20, cidr = "10.20.0.0/16", gateway = "10.20.0.1" }
    data = { tag = 30, cidr = "10.30.0.0/16", gateway = "10.30.0.1" }
    prod = { tag = 50, cidr = "10.50.0.0/16", gateway = "10.50.0.1" }
  }

  # Image key (used as `image = "..."` in VM definitions) -> uploaded file.
  cloud_images = {
    debian = proxmox_download_file.debian_13.id
    ubuntu = proxmox_download_file.ubuntu_2604.id
  }

  cloud_snippets = {
    qemu_guest_agent_debian = proxmox_virtual_environment_file.vendor_data.id
    qemu_guest_agent_ubuntu = proxmox_virtual_environment_file.vendor_data.id
  }

  # Reusable Proxmox security groups.
  common_security_groups = {
    ssh_in = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "22", comment = "SSH" },
    ]
    http_in = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "80", comment = "HTTP" },
    ]
    https_in = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "443", comment = "HTTPS" },
    ]
  }

  # Shared settings passed to every VM module instance as one object.
  common = {
    node_name       = var.node_name
    trunk_bridge    = var.trunk_bridge
    storage_disks   = var.storage_disks
    vlans           = local.vlans
    images          = local.cloud_images
    snippets        = local.cloud_snippets
    vm_user         = var.vm_user
    ssh_public_keys = var.ssh_public_keys
    dns_servers     = var.dns_servers
    dns_domain      = var.dns_domain
  }
}
