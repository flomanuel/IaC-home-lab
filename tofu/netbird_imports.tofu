# Groups

data "netbird_group" "default_group_all" {
  id = "dae59o3l0ubs73bf1ke0"
}

# Router

data "netbird_network_router" "opnsense_helldiek" {
  id         = "dae5f4bl0ubs73bis6dg"
  network_id = netbird_network.helldiek.id
}

# Peers
data "netbird_peers" "user_peers" {
  # All parameters are optional, peers matching all included criteria are return in ids field
  name                          = "Production"
  ip                            = "1.2.3.4"
  connection_ip                 = "12.2.3.4"
  dns_label                     = "test.local"
  user_id                       = ""
  hostname                      = "prod"
  country_code                  = "EG"
  city_name                     = "Cairo"
  os                            = "Ubuntu 24.04"
  connected                     = false
  ssh_enabled                   = true
  inactivity_expiration_enabled = false
  approval_required             = false
  login_expiration_enabled      = false
  login_expired                 = false
  geoname_id                    = 360630
  # Peers containing all groups mentioned are included, even if they have more groups attached
  groups = [data.netbird_group.example.id]
}