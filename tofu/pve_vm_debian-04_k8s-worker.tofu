resource "cloudflare_dns_record" "debian-04_dot_prod_dot_home" {
  zone_id = var.zone_id_1
  name    = "debian-04.prod.home"
  content = "10.50.0.14"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;proxmox"
}

resource "cloudflare_dns_record" "debian-04_dot_mgmt_dot_home" {
  zone_id = var.zone_id_1
  name    = "debian-04.mgmt.home"
  content = "10.20.0.14"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;proxmox"
}

module "debian-04" {
  source = "./modules/vm"
  common = local.common

  name  = "debian-04"
  image = "debian"
  snippet = "qemu_guest_agent_debian"
  agent_enabled = true

  networks = [
    { vlan = "prod", ip = "10.50.0.14/16" },
    { vlan = "mgmt", ip = "10.20.0.14/16" },
  ]

  cores   = 4
  memory  = 8192
  disk_gb = 40

  tags  = ["K8s","K8s_worker"]

  global_security_groups = ["ssh"]
}

output "debian-04" {
  value = module.debian-04.summary
}
