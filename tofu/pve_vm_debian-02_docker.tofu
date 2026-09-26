resource "cloudflare_dns_record" "debian-02_dot_prod_dot_home" {
  zone_id = var.zone_id_1
  name    = "debian-02.prod.home"
  content = "10.50.0.12"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;proxmox"
}

resource "cloudflare_dns_record" "debian-02_dot_mgmt_dot_home" {
  zone_id = var.zone_id_1
  name    = "debian-02.mgmt.home"
  content = "10.20.0.12"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;proxmox"
}

resource "cloudflare_dns_record" "debian-02_dot_data_dot_home" {
  zone_id = var.zone_id_1
  name    = "debian-02.data.home"
  content = "10.30.0.12"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;proxmox"
}

module "debian-02" {
  source       = "./modules/vm"
  common       = local.common
  create_after = [module.debian-01]

  name          = "debian-02"
  image         = "debian"
  snippet       = "qemu_guest_agent_debian"
  agent_enabled = true

  networks = [
    { vlan = "prod", ip = "10.50.0.12/16" },
    { vlan = "data", ip = "10.30.0.12/16" },
    { vlan = "mgmt", ip = "10.20.0.12/16" },
  ]

  cores   = 4
  memory  = 8192
  disk_gb = 40

  tags = ["docker-compose", "applications"]

  global_security_groups = ["ssh", "http", "https"]
}

output "debian-02" {
  value = module.debian-02.summary
}
