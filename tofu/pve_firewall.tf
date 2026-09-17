locals {
  # Reusable Proxmox security groups, shared cluster-wide. A VM attaches one
  # by key via `global_security_groups = ["ssh"]` (see modules/vm/variables.tf).
  # Add new global groups here.
  common_security_groups = {
    ssh = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "22", comment = "SSH" },
    ]
    http = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "80", comment = "HTTP" },
    ]
    https = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "443", comment = "HTTPS" },
    ]
  }
}

resource "proxmox_virtual_environment_cluster_firewall_security_group" "common" {
  for_each = local.common_security_groups

  name    = each.key
  comment = "Managed by Tofu"

  dynamic "rule" {
    for_each = each.value
    content {
      type    = rule.value.type
      action  = rule.value.action
      proto   = try(rule.value.proto, null)
      dport   = try(rule.value.dport, null)
      sport   = try(rule.value.sport, null)
      source  = try(rule.value.source, null)
      dest    = try(rule.value.dest, null)
      comment = try(rule.value.comment, null)
      iface   = try(rule.value.iface, null)
    }
  }
}
