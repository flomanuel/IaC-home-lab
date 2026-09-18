output "name" {
  value = proxmox_virtual_environment_vm.this.name
}

output "vm_id" {
  value = proxmox_virtual_environment_vm.this.vm_id
}

output "primary_ip" {
  description = "IP of the first NIC, without prefix length — use as ansible_host."
  value       = split("/", var.networks[0].ip)[0]
}

output "summary" {
  value = {
    vm_id = proxmox_virtual_environment_vm.this.vm_id
    ips   = { for net in var.networks : net.vlan => net.ip }
  }
}
