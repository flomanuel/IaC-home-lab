resource "cloudflare_dns_record" "debian-09_dot_prod_dot_home" {
  zone_id = var.zone_id_1
  name    = "debian-09.prod.home"
  content = "10.50.0.19"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;hermes"
}

# Hermes (Nous Research) agent + web UI. Base hardening only (bare_hosts in
# Ansible); the app itself is set up manually afterwards.
# Traefik runs on a docker host and will reverse-proxy to this VM via the file
# provider (see GitOps-Docker/traefik/dynamic/), so the web UI must listen on
# port 80/443 here — only 22/80/443 are opened by the firewall below.
module "debian-09" {
  source       = "./modules/vm"
  common       = local.common
  create_after = [module.debian-08]

  name          = "debian-09"
  image         = "debian"
  snippet       = "qemu_guest_agent_debian"
  agent_enabled = true

  networks = [
    { vlan = "prod", ip = "10.50.0.19/16" },
  ]

  cores   = 2
  memory  = 8192 # MiB (8 GiB)
  disk_gb = 60

  tags = ["hermes"]

  # Ports 22 (SSH), 80 and 443 (web UI behind traefik).
  global_security_groups = ["ssh", "http"]
}

output "debian-09" {
  value = module.debian-09.summary
}
