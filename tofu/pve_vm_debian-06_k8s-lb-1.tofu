resource "cloudflare_dns_record" "k8s-lb-1_dot_prod_dot_home" {
  zone_id = var.zone_id_1
  name    = "k8s-lb-1.prod.home"
  content = "10.50.0.16"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;proxmox"
}

resource "cloudflare_dns_record" "k8s-lb-1_dot_mgmt_dot_home" {
  zone_id = var.zone_id_1
  name    = "k8s-lb-1.mgmt.home"
  content = "10.20.0.16"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;proxmox"
}

module "k8s-lb-1" {
  source = "./modules/vm"
  common = local.common
  create_after = [module.k8s-worker-2]

  name          = "k8s-lb-1"
  image         = "debian"
  snippet       = "qemu_guest_agent_debian"
  agent_enabled = true

  networks = [
    { vlan = "prod", ip = "10.50.0.16/16" },
    { vlan = "mgmt", ip = "10.20.0.16/16" },
  ]

  cores   = 2
  memory  = 4096
  disk_gb = 40

  tags = ["K8s", "k8s_lb"]

  global_security_groups = [
    "ssh",
    "k8s_api_admin", "k8s_registration"
  ]
}

output "k8s-lb-1" {
  value = module.k8s-lb-1.summary
}
