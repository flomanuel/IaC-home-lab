resource "netbird_nameserver_group" "dns_helldiek" {
  name        = "OPNsense Helldiek"
  description = "DNS server located in Helldiek"
  nameservers = [
    {
      ip      = "10.50.0.1"
      ns_type = "udp"
      port    = 53
    },
  ]
  groups                 = [netbird_group.sauers.id]
  search_domains_enabled = false
  enabled                = true
  primary                = true
}

resource "netbird_nameserver_group" "dns_cloudflare" {
  name        = "Cloudflare"
  description = "Cloudflare fallback"
  nameservers = [
    {
      ip      = "1.1.1.1"
      ns_type = "udp"
      port    = 53
    },
    {
      ip      = "1.0.0.1"
      ns_type = "udp"
      port    = 53
    }
  ]
  groups                 = [data.netbird_group.default_group_all.id]
  search_domains_enabled = false
  enabled                = true
  primary                = false
}

resource "netbird_nameserver_group" "dns_quad9" {
  name        = "Quad9"
  description = "Quad9 fallback"
  nameservers = [
    {
      ip      = "9.9.9.9"
      ns_type = "udp"
      port    = 53
    },
    {
      ip      = "149.112.112.112"
      ns_type = "udp"
      port    = 53
    }
  ]
  groups                 = [data.netbird_group.default_group_all.id]
  search_domains_enabled = false
  enabled                = true
  primary                = false
}
