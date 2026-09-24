# Peers of user-facing groups are managed via netbird_user.auto_groups,
# so `peers` is intentionally omitted (optional + computed).
resource "netbird_group" "sauers" {
  name = "sauers"
}

resource "netbird_group" "opnsense_helldiek" {
  name  = "OPNsense_Helldiek"
  peers = [data.netbird_peer.opnsense_helldiek.id]
}

resource "netbird_group" "k8s_admins" {
  name = "K8s Admins"
}

resource "netbird_group" "admins_baseline" {
  name = "Admins (baseline)"
}
