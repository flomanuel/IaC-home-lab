# DNS records that are not directly connected to LXC or a Proxmox VM.

# ====== Proxmox 1 ======

resource "cloudflare_dns_record" "proxmox-1_dot_mgmt_dot_home" {
  zone_id = var.zone_id_1
  name    = "proxmox-1.mgmt.home"
  content = "10.20.0.50"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;proxmox"
}

# ====== TrueNAS Containers ======

resource "cloudflare_dns_record" "proxmox-backup-server_dot_mgmt_dot_home" {
  zone_id = var.zone_id_1
  name    = "proxmox-backup-server.mgmt.home"
  content = "10.20.1.103"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;TrueNAS"
}

resource "cloudflare_dns_record" "s3-storage_dot_mgmt_dot_home" {
  zone_id = var.zone_id_1
  name    = "s3-storage.mgmt.home"
  content = "10.20.1.148"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;TrueNAS"
}

resource "cloudflare_dns_record" "s3-storage_dot_data_dot_home" {
  zone_id = var.zone_id_1
  name    = "s3-storage.data.home"
  content = "10.30.1.128"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;TrueNAS"
}

# ====== TrueNAS Hosts ======

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

# ====== Kubernetes ======

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
