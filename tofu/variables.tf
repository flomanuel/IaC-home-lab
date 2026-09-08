variable "node_name" {
  description = "Proxmox node name (see the sidebar in the Proxmox UI)."
  type        = string
}

variable "proxmox_insecure" {
  description = "Skip TLS verification (self-signed Proxmox certificate)."
  type        = bool
  default     = true
}

variable "ssh_agent" {
  description = "Enable SSH access (needed to upload snippets)."
  type        = bool
  default     = true
}

variable "ssh_username" {
  description = "The SSH username"
  type        = string
}

variable "ssh_keypath" {
  description = "Path to SSH pub key."
  type        = string
}

variable "trunk_bridge" {
  description = "VLAN-aware bridge on the trunk NIC (set up manually on the host)."
  type        = string
  default     = "vmbr1"
}

variable "storage_images" {
  description = "File-capable storage for downloaded cloud images (dir storage on rpool)."
  type        = string
  default     = "local"
}

variable "storage_files" {
  description = "File-capable storage for files (dir storage on rpool)."
  type        = string
  default     = "local"
}

variable "storage_disks" {
  description = "Storage for VM disks and cloud-init drives."
  type        = string
  default     = "vm_pool"
}

variable "vm_user" {
  description = "Admin user created by cloud-init in every Linux VM (must match admin_user in ansible/inventory/group_vars/all/main.yml)."
  type        = string
  default     = "admin"
}

variable "ssh_public_keys" {
  description = "SSH public keys installed for vm_user via cloud-init. Set in terraform.tfvars (see terraform.tfvars.example)."
  type        = list(string)
}

variable "dns_servers" {
  description = "DNS servers handed to VMs via cloud-init."
  type        = list(string)
}

variable "dns_domain" {
  description = "DNS search domain."
  type = string
}
