# Peers registered by a user are added to its auto_groups. With
# groups_propagation_enabled, changes here are propagated to existing peers,
# which is why the user-facing groups do not list their peers explicitly.
resource "netbird_user" "florian_sauer" {
  is_service_user = false
  role            = "owner"
  auto_groups = [
    netbird_group.admins_baseline.id,
    netbird_group.sauers.id,
    netbird_group.k8s_admins.id,
  ]
}
