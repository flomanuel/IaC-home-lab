resource "cloudflare_dns_record" "debian-01_dot_prod_dot_home" {
  zone_id = var.zone_id_1
  name    = "debian-01.prod.home"
  content = "10.50.0.11"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;proxmox"
}

resource "cloudflare_dns_record" "debian-01_dot_data_dot_home" {
  zone_id = var.zone_id_1
  name    = "debian-01.data.home"
  content = "10.30.0.11"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;proxmox"
}

resource "cloudflare_dns_record" "debian-01_dot_mgmt_dot_home" {
  zone_id = var.zone_id_1
  name    = "debian-01.mgmt.home"
  content = "10.20.0.11"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;proxmox"
}

module "debian-01" {
  source = "./modules/vm"
  common = local.common

  name          = "debian-01"
  image         = "debian"
  snippet       = "qemu_guest_agent_debian"
  agent_enabled = true

  networks = [
    { vlan = "prod", ip = "10.50.0.11/16" },
    { vlan = "data", ip = "10.30.0.11/16" },
    { vlan = "mgmt", ip = "10.20.0.11/16" },
  ]

  cores   = 4
  memory  = 8192 # MiB
  disk_gb = 40

  tags = ["docker-compose", "db", "secrets"]

  global_security_groups = ["ssh", "http", "https"]

  # net0 = prod, net1 = data, net2 = mgmt (order of `networks`)
  custom_firewall_rules = {
    postgres = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "5432", comment = "PostgreSQL", iface = "net1" },
    ]
    pgadmin = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "5050", comment = "pgAdmin", iface = "net2" },
    ]
    # redis = [
    #   { type = "in", action = "ACCEPT", proto = "tcp", dport = "6379", comment = "Redis", iface = "net1" },
    # ]
  }
}

output "debian-01" {
  value = module.debian-01.summary
}
