# Rules target network resources/peers via `destination_resource`;
# `destinations` only accepts group IDs.

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
    name          = "Admin: K8s API"
    description   = "Allow admins to access the K8s API port on the control plane."
    sources       = [netbird_group.k8s_admins.id]
    destination_resource = {
      id   = netbird_network_resource.helldiek_k8s_control_plane.id
      type = "subnet"
    }
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
    name          = "Admin: MGMT"
    description   = "Allow admins access to the management network in Helldiek, Bassum, Germany."
    sources       = [netbird_group.admins_baseline.id]
    destination_resource = {
      id   = netbird_network_resource.helldiek_mgmt.id
      type = "subnet"
    }
  }
}

resource "netbird_policy" "admin_tp-link" {
  name        = "Admin: TP-Link UI"
  description = "Allow access to the TP-Link managed switch (Helldiek, Bassum, Germany) web UI."
  enabled     = true

  rule {
    action        = "accept"
    bidirectional = false
    enabled       = true
    protocol      = "tcp"
    ports         = ["80", "443"]
    name          = "Admin: TP-Link UI"
    description   = "Allow access to the TP-Link managed switch (Helldiek, Bassum, Germany) web UI."
    sources       = [netbird_group.admins_baseline.id]
    destination_resource = {
      id   = netbird_network_resource.helldiek_tp-link.id
      type = "host"
    }
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
    name          = "Sauers: PROD (web apps)"
    description   = "Helldiek Network, Network for Home Lab in Helldiek, Bassum, Germany."
    sources       = [netbird_group.sauers.id]
    destination_resource = {
      id   = netbird_network_resource.helldiek_prod.id
      type = "subnet"
    }
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
    name          = "Sauers: Data access"
    description   = "Helldiek Network, Network for Home Lab in Helldiek, Bassum, Germany."
    sources       = [netbird_group.sauers.id]
    destination_resource = {
      id   = netbird_network_resource.helldiek_data.id
      type = "subnet"
    }
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
    name          = "Sauers: Helldiek peer"
    description   = "Allow sauers to access the dev peer in order to use the DNS on the peer's host (OPNsense)."
    sources       = [netbird_group.sauers.id]
    destination_resource = {
      id   = data.netbird_peer.opnsense_helldiek.id
      type = "peer"
    }
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
    name          = "Admin: PROD access"
    description   = "Access to admin-endpoints in PROD"
    sources       = [netbird_group.admins_baseline.id]
    destination_resource = {
      id   = netbird_network_resource.helldiek_prod.id
      type = "subnet"
    }
  }
}
