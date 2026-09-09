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
  ]

  cores   = 4
  memory  = 8192 # MiB
  disk_gb = 20

  tags  = ["docker","docker-compose"]

  # Shared groups defined once in tofu/firewall.tf, attached by key.
  global_security_groups = ["ssh", "http", "https"]

  # This VM's own one-off rules (not shared with other VMs).
  custom_firewall_rules = {
#    nfs4 = [
#      { type = "in", action = "ACCEPT", proto = "tcp", dport = "2049", comment = "NFSv4", iface = "net1" },
#    ]
  }
}

output "debian-01" {
  value = module.debian-01.summary
}
