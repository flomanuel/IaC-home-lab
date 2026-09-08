resource "proxmox_virtual_environment_file" "vendor_data" {
  node_name    = var.node_name
  datastore_id = var.storage_files   # needs "snippets" content type enabled
  content_type = "snippets"

  source_raw {
    file_name = "vendor-data-qemu-guest-agent.yaml"
    data      = <<-EOT
      #cloud-config
      package_update: true
      packages:
        - qemu-guest-agent
      runcmd:
        - systemctl enable --now qemu-guest-agent
    EOT
  }
}