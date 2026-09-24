# Groups

data "netbird_group" "default_group_all" {
  id = "dae59o3l0ubs73bf1ke0"
}

# Peers

data "netbird_peer" "opnsense_helldiek" {
  id = "dae5f4bl0ubs73bis6dg"
}

# Router

data "netbird_network_router" "opnsense_helldiek" {
  id         = "dae6il3l0ubs73cg4c9g"
  network_id = netbird_network.helldiek.id
}
