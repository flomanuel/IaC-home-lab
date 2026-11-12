resource "cloudflare_dns_record" "debian-08_dot_prod_dot_home" {
  zone_id = var.zone_id_1
  name    = "debian-08.prod.home"
  content = "10.50.0.18"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;proxmox"
}

resource "cloudflare_dns_record" "acn_dot_home" {
  zone_id = var.zone_id_1
  name    = "acn.home"
  content = "10.50.0.18"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;acn"
}

module "debian-08" {
  source       = "./modules/vm"
  common       = local.common
  create_after = [module.debian-07]

  name          = "debian-08"
  image         = "debian"
  snippet       = "qemu_guest_agent_debian"
  agent_enabled = true

  # First entry = primary NIC, gets the default gateway.
  networks = [
    { vlan = "prod", ip = "10.50.0.18/16" },
  ]

  cores   = 4
  memory  = 12288 # MiB (12 GiB)
  disk_gb = 100

  tags = ["acn"]

  global_security_groups = ["ssh"]

  custom_firewall_rules = {
    containerlab = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "5201", comment = "iperf3" },
    ]
  }


}

output "debian-08" {
  value = module.debian-08.summary
}
