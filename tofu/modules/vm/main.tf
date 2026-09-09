resource "proxmox_virtual_environment_vm" "this" {
  name      = var.name
  node_name = var.common.node_name
  vm_id     = var.vm_id
  tags      = sort(concat(["tofu"], var.tags))
  on_boot   = var.start_on_boot

  # Without the agent, a graceful shutdown on destroy would wait for ACPI. Stop instead.
  stop_on_destroy = !var.agent_enabled

  agent {
    enabled = var.agent_enabled
    timeout = "5m"
  }

  cpu {
    cores = var.cores
    type  = "host"
  }

  memory {
    dedicated = var.memory
  }
  
  scsi_hardware = "virtio-scsi-single"
  
  disk {
    datastore_id = var.common.storage_disks
    file_id      = var.common.images[var.image]
    interface    = "scsi0"
    size         = var.disk_gb
    discard      = "on"
    iothread     = true
  }

  # Cloud images use the serial console.
  serial_device {}

  operating_system {
    type = "l26"
  }

  dynamic "network_device" {
    for_each = var.networks
    content {
      bridge   = var.common.trunk_bridge
      vlan_id  = var.common.vlans[network_device.value.vlan].tag
      firewall = length(var.security_groups) > 0
    }
  }

  initialization {
    datastore_id = var.common.storage_disks

    vendor_data_file_id = var.common.snippets[var.snippet]

    dynamic "ip_config" {
      for_each = { for idx, net in var.networks : idx => net }
      content {
        ipv4 {
          address = ip_config.value.ip
          gateway = ip_config.key == "0" ? var.common.vlans[ip_config.value.vlan].gateway : null
        }
      }
    }

    dns {
      servers = var.common.dns_servers
      domain  = var.common.dns_domain
    }

    user_account {
      username = var.common.vm_user
      keys     = var.common.ssh_public_keys
    }
  }
}
