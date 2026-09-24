resource "netbird_nameserver_group" "dns_helldiek" {
  name        = "OPNsense Helldiek"
  description = "DNS server located in Helldiek, with Cloudflare and Quad9 as fallback"
  nameservers = [
    {
      ip      = "10.50.0.1"
      ns_type = "udp"
      port    = 53
    },
    {
      ip      = "1.1.1.1"
      ns_type = "udp"
      port    = 53
    },
    {
      ip      = "9.9.9.9"
      ns_type = "udp"
      port    = 53
    },
  ]
  groups                 = [netbird_group.sauers.id]
  search_domains_enabled = false
  enabled                = true
  primary                = true
}
