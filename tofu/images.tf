# Official cloud images, downloaded by Proxmox itself onto the file-capable
# storage. The .img file_name is required so Proxmox accepts the qcow2 for
# disk import (file_id in the vm module).
# Note: neither image ships qemu-guest-agent — the Ansible base role installs it.

resource "proxmox_download_file" "debian_13" {
  node_name    = var.node_name
  datastore_id = var.storage_images
  content_type = "import"
  file_name    = "debian-13-genericcloud-amd64-20260831-2587.qcow2"
  url          = "https://cloud.debian.org/images/cloud/trixie/20260831-2587/debian-13-genericcloud-amd64-20260831-2587.qcow2"
}

resource "proxmox_download_file" "ubuntu_2604" {
  node_name    = var.node_name
  datastore_id = var.storage_images
  content_type = "iso"
  file_name    = "noble-server-cloudimg-amd64.img"
  url          = "https://cloud-images.ubuntu.com/noble/20260826/noble-server-cloudimg-amd64.img"
}
