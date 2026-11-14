resource "cloudflare_dns_record" "debian-07_dot_prod_dot_home" {
  zone_id = var.zone_id_1
  name    = "debian-07.prod.home"
  content = "10.50.0.17"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;proxmox"
}

module "debian-07" {
  source       = "./modules/vm"
  common       = local.common
  create_after = [module.k8s-worker-3]

  # Deactivated: VM is kept, but stopped and not started on host boot.
  started       = true
  start_on_boot = true

  name          = "debian-07"
  image         = "debian"
  snippet       = "qemu_guest_agent_debian"
  agent_enabled = true

  # First entry = primary NIC, gets the default gateway.
  networks = [
    { vlan = "prod", ip = "10.50.0.17/16" },
  ]

  # Remote coding agents are light (the model runs remotely); the headroom is
  # for what they run: builds, tests, package installs.
  cores   = 8
  memory  = 16384 # MiB
  disk_gb = 40

  tags = ["remote-code"]

  global_security_groups = ["ssh"]
}

output "debian-07" {
  value = module.debian-07.summary
}
