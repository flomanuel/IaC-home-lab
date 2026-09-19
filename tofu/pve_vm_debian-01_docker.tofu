# Cloudflare DNS records
resource "cloudflare_dns_record" "debian-01_dot_prod_dot_home" {
  zone_id = var.zone_id_1
  name    = "debian-01.prod.home"
  content = "10.50.1.10"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;proxmox"
}

resource "cloudflare_dns_record" "debian-01_dot_data_dot_home" {
  zone_id = var.zone_id_1
  name    = "debian-01.data.home"
  content = "10.30.1.10"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;proxmox"
}

resource "cloudflare_dns_record" "debian-01_dot_mgmt_dot_home" {
  zone_id = var.zone_id_1
  name    = "debian-01.mgmt.home"
  content = "10.20.1.10"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;proxmox"
}

# VM config
module "debian-01" {
  source = "./modules/vm"
  common = local.common

  name  = "debian-01"
  image = "debian"
  snippet = "qemu_guest_agent_debian"
  agent_enabled = true

  # First entry = primary NIC, gets the default gateway.
  # Add a second entry in VLAN "data" only if this VM needs TrueNAS NFS.
  networks = [
    { vlan = "prod", ip = "10.50.1.10/16" },
    { vlan = "data", ip = "10.30.1.10/16" },
    { vlan = "mgmt", ip = "10.20.1.10/16" },
  ]

  cores   = 4
  memory  = 8192 # MiB
  disk_gb = 20

  tags  = ["docker-compose","applications"]

  # Shared groups defined once in tofu/firewall.tf, attached by key.
  global_security_groups = ["ssh", "http", "https"]

}

output "debian-01" {
  value = module.debian-01.summary
}
