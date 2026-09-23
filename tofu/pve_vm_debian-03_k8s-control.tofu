resource "cloudflare_dns_record" "k8s-control-1_dot_prod_dot_home" {
  zone_id = var.zone_id_1
  name    = "k8s-control-1.prod.home"
  content = "10.50.0.13"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;K8s"
}

resource "cloudflare_dns_record" "k8s-control-1_dot_mgmt_dot_home" {
  zone_id = var.zone_id_1
  name    = "k8s-control-1.mgmt.home"
  content = "10.20.0.13"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;K8s"
}

module "k8s-control-1" {
  source       = "./modules/vm"
  common       = local.common
  create_after = [module.debian-02]

  name          = "k8s-control-1"
  image         = "debian"
  snippet       = "qemu_guest_agent_debian"
  agent_enabled = true

  networks = [
    { vlan = "prod", ip = "10.50.0.13/16" },
    { vlan = "mgmt", ip = "10.20.0.13/16" },
  ]

  cores   = 4
  memory  = 8192
  disk_gb = 60

  # Dedicated SSD disk for etcd, mounted by the Ansible role k8s_etcd_disk.
  data_disks = [
    { datastore_id = var.storage_fast_disks, size = 8, serial = "k3s-etcd" },
  ]

  tags = ["K8s", "K8s_control"]

  global_security_groups = [
    "ssh", "http", "https",
    "k8s_api_cluster", "k8s_api_admin", "k8s_etcd_client", "k8s_etcd_peer", "k8s_etcd_metrics", "metallb_memberlist", # K8s server rules
    "k8s_kubelet_metric", "k8s_nodeport", "k8s_cni_vxlan"                                                             # K8s rules for all nodes
  ]

}

output "k8s-control-1" {
  value = module.k8s-control-1.summary
}
