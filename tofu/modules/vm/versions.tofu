terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
    }
  }
}
