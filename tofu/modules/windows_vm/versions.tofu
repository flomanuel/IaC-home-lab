terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
    netbird = {
      source = "registry.terraform.io/netbirdio/netbird"
    }
  }
}
