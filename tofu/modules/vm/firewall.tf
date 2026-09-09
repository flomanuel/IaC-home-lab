locals {
  # A rule referencing one of this VM's attached global security groups.
  global_rule_entries = [
    for key in var.global_security_groups : {
      security_group = var.common.security_groups[key]
      type           = null
      action         = null
      proto          = null
      dport          = null
      sport          = null
      source         = null
      dest           = null
      comment        = null
      iface          = null
    }
  ]

  # This VM's own direct rules (not wrapped in a security group).
  custom_rule_entries = [
    for rule in flatten(values(var.custom_firewall_rules)) : {
      security_group = null
      type           = rule.type
      action         = rule.action
      proto          = try(rule.proto, null)
      dport          = try(rule.dport, null)
      sport          = try(rule.sport, null)
      source         = try(rule.source, null)
      dest           = try(rule.dest, null)
      comment        = try(rule.comment, null)
      iface          = try(rule.iface, null)
    }
  ]

  firewall_active = length(var.global_security_groups) > 0 || length(var.custom_firewall_rules) > 0
}

resource "proxmox_virtual_environment_firewall_options" "this" {
  count = local.firewall_active ? 1 : 0

  node_name = proxmox_virtual_environment_vm.this.node_name
  vm_id     = proxmox_virtual_environment_vm.this.vm_id

  enabled = true
}

resource "proxmox_virtual_environment_firewall_rules" "this" {
  count = local.firewall_active ? 1 : 0

  node_name = proxmox_virtual_environment_vm.this.node_name
  vm_id     = proxmox_virtual_environment_vm.this.vm_id

  dynamic "rule" {
    for_each = concat(local.global_rule_entries, local.custom_rule_entries)
    content {
      security_group = rule.value.security_group
      type           = rule.value.type
      action         = rule.value.action
      proto          = rule.value.proto
      dport          = rule.value.dport
      sport          = rule.value.sport
      source         = rule.value.source
      dest           = rule.value.dest
      comment        = rule.value.comment
      iface          = rule.value.iface
    }
  }
}
