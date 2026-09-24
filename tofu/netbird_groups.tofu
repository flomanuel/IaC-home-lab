resource "netbird_group" "sauers" {
  name  = "sauers"
  peers = []
}

resource "netbird_group" "opnsense_helldiek" {
  name  = "OPNsense_Helldiek"
  peers = []
}

resource "netbird_group" "k8s_admins" {
  name  = "K8s Admins"
  peers = []
}

resource "netbird_group" "admins_baseline" {
  name  = "Admins (baseline)"
  peers = []
}
