resource "netbird_account_settings" "settings" {
  user_approval_required = true
  peer_login_expiration = 86400 # 24 hours
  groups_propagation_enabled = true
}
