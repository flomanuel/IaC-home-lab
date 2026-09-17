resource "cloudflare_dns_record" "proxmox-1_dot_mgmt_dot_home" {
  zone_id = var.zone_id_sauers_dot_link
  name    = "proxmox-1.mgmt.home"
  content = "10.20.0.50"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;proxmox"
}

resource "cloudflare_dns_record" "proxmox-backup-server_dot_mgmt_dot_home" {
  zone_id = var.zone_id_sauers_dot_link
  name    = "proxmox-backup-server.mgmt.home"
  content = "10.20.1.103"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;proxmox"
}

resource "cloudflare_dns_record" "truenas_dot_data_dot_home" {
  zone_id = var.zone_id_sauers_dot_link
  name    = "truenas.data.home"
  content = "10.30.0.50"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;TrueNAS"
}

resource "cloudflare_dns_record" "truenas_dot_mgmt_dot_home" {
  zone_id = var.zone_id_sauers_dot_link
  name    = "truenas.mgmt.home"
  content = "10.20.0.52"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;TrueNAS"
}

resource "cloudflare_dns_record" "truenas-old_dot_mgmt_dot_home" {
  zone_id = var.zone_id_sauers_dot_link
  name    = "truenas-old.mgmt.home"
  content = "10.20.0.51"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;TrueNAS"
}
