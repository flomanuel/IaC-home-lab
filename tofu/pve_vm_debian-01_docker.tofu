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

resource "cloudflare_dns_record" "wildcard_dot_debian-01_dot_data_dot_home" {
  zone_id = var.zone_id_1
  name    = "*.debian-01.data.home"
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

resource "cloudflare_dns_record" "wildcard_dot_debian-01_dot_mgmt_dot_home" {
  zone_id = var.zone_id_1
  name    = "*.debian-01.mgmt.home"
  content = "10.20.0.11"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "tofu;home-lab;proxmox"
}

resource "cloudflare_dns_record" "wildcard_dot_debian-01_dot_prod_dot_home" {
  zone_id = var.zone_id_1
  name    = "*.debian-01.prod.home"
  content = "10.50.0.11"
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

  # Dedicated SSD disk for postgres, mounted by the Ansible role data_disks
  # (serial must match `data_disks` in ansible/inventory/host_vars/debian-01.yml).
  data_disks = [
    { datastore_id = var.storage_fast_disks, size = 10, serial = "postgres-data" },
  ]

  # Intel Arc A310 for HW transcoding in containers. The Resource Mapping is
  # created by hand on Proxmox (root@pam only); guest setup:
  # docs/runbooks/arc-a310-debian-01.md
  machine = "q35"
  pci_devices = [
    { mapping = "arc-a310" },
  ]

  tags = ["docker-compose", "db", "secrets"]

  global_security_groups = ["ssh", "http", "https"]

  # net0 = prod, net1 = data, net2 = mgmt (order of `networks`)
  custom_firewall_rules = {
    postgres = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "5432", comment = "PostgreSQL (traefik, TLS)", iface = "net1" },
    ]
    # pgAdmin and the Dockhand UI are served by traefik on the MGMT address (https group).
    dockhand = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "3000", source = local.admin_ips, comment = "Dockhand break-glass (no traefik)", iface = "net2" },
    ]
    jellyfin_remote = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "4444", comment = "Jellyin from family home net" },
    ]
  }
}

output "debian-01" {
  value = module.debian-01.summary
}
