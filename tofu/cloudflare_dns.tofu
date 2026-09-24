# DNS records that are not directly connected to LXC or a Proxmox VM.

resource "cloudflare_dns_record" "proxmox-1_dot_mgmt_dot_home" {
  zone_id = var.zone_id_1
  name    = "proxmox-1.mgmt.home"
  content = "10.20.0.50"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;proxmox"
}

resource "cloudflare_dns_record" "proxmox-backup-server_dot_mgmt_dot_home" {
  zone_id = var.zone_id_1
  name    = "proxmox-backup-server.mgmt.home"
  content = "10.20.1.103"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;proxmox"
}

resource "cloudflare_dns_record" "truenas_dot_data_dot_home" {
  zone_id = var.zone_id_1
  name    = "truenas.data.home"
  content = "10.30.0.50"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;TrueNAS"
}

resource "cloudflare_dns_record" "truenas_dot_mgmt_dot_home" {
  zone_id = var.zone_id_1
  name    = "truenas.mgmt.home"
  content = "10.20.0.52"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;TrueNAS"
}

resource "cloudflare_dns_record" "truenas-old_dot_mgmt_dot_home" {
  zone_id = var.zone_id_1
  name    = "truenas-old.mgmt.home"
  content = "10.20.0.51"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;TrueNAS"
}

resource "cloudflare_dns_record" "k8s-prod-1_dot_home" {
  zone_id = var.zone_id_1
  name    = "k8s-prod-1.home"
  content = "10.50.0.10" # virtual ip address for the control plane (kube-vip load balancer)
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;K8s"
}

resource "cloudflare_dns_record" "wildcard_dot_k8s-prod-1_dot_home" {
  zone_id = var.zone_id_1
  name    = "*.k8s-prod-1.home"
  content = "10.50.2.100" # ip address of the traefik service load balancer
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;K8s;traefik"
}
