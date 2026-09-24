resource "netbird_policy" "admin_k8s" {
  name        = "Admin: K8s API"
  description = "Allow admins to access the K8s API port."
  enabled     = true

  rule {
    action        = "accept"
    bidirectional = false
    enabled       = true
    protocol      = "tcp"
    ports         = ["6443"]
    name          = "K8s api access"
    sources       = [netbird_group.k8s_admins.id]
    destinations  = [netbird_network_resource.helldiek_prod.id]
  }
}

resource "netbird_policy" "admin_mgmt" {
  name        = "Admin: MGMT"
  description = "Allow admins access to the management network in Helldiek, Bassum, Germany."
  enabled     = true

  rule {
    action        = "accept"
    bidirectional = false
    enabled       = true
    protocol      = "all"
    name          = "Management-access"
    sources       = [netbird_group.admins_baseline.id]
    destinations  = [netbird_network_resource.helldiek_mgmt.id]
  }
}

resource "netbird_policy" "admin_tp-link" {
  name        = "Admin: TP-Link UI"
  description = "Allow access to the TP-Link managed switch (Helldiek, Bassum, Germany) web ui."
  enabled     = true

  rule {
    action        = "accept"
    bidirectional = false
    enabled       = true
    protocol      = "tcp"
    ports         = ["80", "443"]
    name          = "TP-Link-access"
    sources       = [netbird_group.admins_baseline.id]
    destinations  = [netbird_network_resource.helldiek_tp-link.id]
  }
}

resource "netbird_policy" "sauers_prod" {
  name        = "Sauers: PROD (web apps)"
  description = "Helldiek Network, Network for Home Lab in Helldiek, Bassum, Germany."
  enabled     = true

  rule {
    action        = "accept"
    bidirectional = false
    enabled       = true
    protocol      = "tcp"
    ports         = ["80", "443"]
    name          = "Sauers prod"
    sources       = [netbird_group.sauers.id]
    destinations  = [netbird_network_resource.helldiek_prod.id]
  }
}

resource "netbird_policy" "sauers_data" {
  name        = "Sauers: Data access"
  description = "Helldiek Network, Network for Home Lab in Helldiek, Bassum, Germany."
  enabled     = true

  rule {
    action        = "accept"
    bidirectional = false
    enabled       = true
    protocol      = "tcp"
    ports         = ["445"]
    name          = "Sauers data"
    sources       = [netbird_group.sauers.id]
    destinations  = [netbird_network_resource.helldiek_data.id]
  }
}

resource "netbird_policy" "sauers_helldiek-peer" {
  name        = "Sauers: Helldiek peer"
  description = "Allow sauers to access the dev peer in order to use the DNS on the peer's host (OPNsense)."
  enabled     = true

  rule {
    action        = "accept"
    bidirectional = false
    enabled       = true
    protocol      = "all"
    name          = "TP-Link-access"
    sources       = [netbird_group.sauers.id]
    destinations  = [data.netbird_network_router.opnsense_helldiek.id]
  }
}

resource "netbird_policy" "admin_prod" {
  name        = "Admin: PROD access"
  description = "Access to admin-endpoints in PROD"
  enabled     = true

  rule {
    action        = "accept"
    bidirectional = false
    enabled       = true
    protocol      = "tcp"
    ports         = ["22"]
    name          = "TP-Link-access"
    sources       = [netbird_group.admins_baseline.id]
    destinations  = [netbird_network_resource.helldiek_prod.id]
  }
}
