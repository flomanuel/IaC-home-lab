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

  # Each key becomes a Proxmox security group ("debian-01-<key>") and is
  # applied as a rule on this VM's firewall.
  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_cluster_firewall_security_group
  security_groups = {
    ssh = local.common_security_groups.ssh_in
    http = local.common_security_groups.http_in
    https = local.common_security_groups.https_in
#    nfs4 = [
#      { type = "out", action = "ACCEPT", proto = "tcp", dport = "2049", comment = "NFSv4", iface = "net1"},
#    ]
#    inet = [
#      { type = "out", action = "ACCEPT", comment = "INTERNET ACCESS", iface = "net0"},
#    ]
  }
}

output "debian-01" {
  value = module.debian-01.summary
}
