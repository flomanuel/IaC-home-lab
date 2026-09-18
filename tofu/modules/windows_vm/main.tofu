# Full clone of the hand-built Windows template. Everything inside the guest
# (IP config, users, updates) is hand-managed; machine type, BIOS/UEFI, TPM
# and disks are inherited from the template.
resource "proxmox_virtual_environment_vm" "this" {
  name      = var.name
  node_name = var.common.node_name
  vm_id     = var.vm_id
  tags      = sort(concat(["tofu", "windows"], var.tags))
  on_boot   = var.start_on_boot

  clone {
    vm_id = var.template_vm_id
    full  = true
  }

  cpu {
    cores = var.cores
    type  = "host"
  }

  memory {
    dedicated = var.memory
  }

  # The template has the guest agent installed (see runbook).
  agent {
    enabled = true
  }

  dynamic "network_device" {
    for_each = var.networks
    content {
      bridge  = var.common.trunk_bridge
      vlan_id = var.common.vlans[network_device.value.vlan].tag
    }
  }
}
