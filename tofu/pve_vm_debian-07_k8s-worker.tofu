resource "cloudflare_dns_record" "k8s-worker-3_dot_prod_dot_home" {
  zone_id = var.zone_id_1
  name    = "k8s-worker-3.prod.home"
  content = "10.50.0.17"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;proxmox"
}

module "k8s-worker-3" {
  source = "./modules/vm"
  common = local.common

  name  = "k8s-worker-3"
  image = "debian"
  snippet = "qemu_guest_agent_debian"
  agent_enabled = true

  networks = [
    { vlan = "prod", ip = "10.50.0.17/16" },
  ]

  cores   = 4
  memory  = 8192
  disk_gb = 40

  tags  = ["K8s","K8s_worker"]

  global_security_groups = [
    "ssh", "https", "http",
    "k8s_kubelet_metric", "k8s_nodeport", "k8s_cni_health", "k8s_cni_vxlan", "metallb_memberlist", # K8s rules for all nodes
  ]
}

output "k8s-worker-3" {
  value = module.k8s-worker-3.summary
}
