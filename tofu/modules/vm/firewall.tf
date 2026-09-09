# This VM's security groups, keyed by name (see variables.tf). Named
# "<vm-name>-<key>" since Proxmox security group names are cluster-wide unique.
resource "proxmox_virtual_environment_cluster_firewall_security_group" "this" {
  for_each = var.security_groups

  name    = "${var.name}-${each.key}"
  comment = "Managed by Tofu (${var.name})"

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

resource "proxmox_virtual_environment_firewall_options" "this" {
  count = length(var.security_groups) > 0 ? 1 : 0

  node_name = proxmox_virtual_environment_vm.this.node_name
  vm_id     = proxmox_virtual_environment_vm.this.vm_id

  enabled = true
}

resource "proxmox_virtual_environment_firewall_rules" "this" {
  count = length(var.security_groups) > 0 ? 1 : 0

  node_name = proxmox_virtual_environment_vm.this.node_name
  vm_id     = proxmox_virtual_environment_vm.this.vm_id

  dynamic "rule" {
    for_each = proxmox_virtual_environment_cluster_firewall_security_group.this
    content {
      security_group = rule.value.name
    }
  }
}
