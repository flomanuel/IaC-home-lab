# ====== Networks ======
resource "netbird_network" "helldiek" {
  name        = "Helldiek"
  description = "Network for the Home Lab in Helldiek, Bassum, Germany."
  # routers = [
  #   data.netbird_network_router.opnsense_helldiek.id
  # ]
}

# ====== Network Resources ======
resource "netbird_network_resource" "helldiek_mgmt" {
  network_id  = netbird_network.helldiek.id
  name        = "Data Network"
  description = "Data network for SMB and NFS shares."
  address     = "10.30.0.0/16"
  groups      = [netbird_group.opnsense_helldiek.id]
  enabled     = true
}

resource "netbird_network_resource" "helldiek_data" {
  network_id  = netbird_network.helldiek.id
  name        = "Management Network"
  description = "Network containing the management web UI for both TrueNAS and Proxmox."
  address     = "10.20.0.0/16"
  groups      = [netbird_group.opnsense_helldiek.id]
  enabled     = true
}

resource "netbird_network_resource" "helldiek_prod" {
  network_id  = netbird_network.helldiek.id
  name        = "Production Network"
  description = "The production network containing several running applications."
  address     = "10.50.0.0/16"
  groups      = [netbird_group.opnsense_helldiek.id]
  enabled     = true
}

resource "netbird_network_resource" "helldiek_tp-link" {
  network_id  = netbird_network.helldiek.id
  name        = "TP-Link Web UI"
  description = "TP-Link managed switch web ui."
  address     = "10.10.0.147/32"
  groups      = [netbird_group.opnsense_helldiek.id]
  enabled     = true
}
