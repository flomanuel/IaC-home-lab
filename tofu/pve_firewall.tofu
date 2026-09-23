locals {
  # Firewall sources for the K8s rules below. Add new nodes here.
  k8s_control_ips = join(",", [module.k8s-control-1.primary_ip, "127.0.0.1"])
  k8s_lb_ip       = module.k8s-lb-1.primary_ip
  k8s_node_ips = join(",", [
    module.k8s-control-1.primary_ip,
    module.k8s-worker-1.primary_ip,
    module.k8s-worker-2.primary_ip,
    module.k8s-worker-3.primary_ip,
    "127.0.0.1"
  ])
  k8s_cluster_ips = "${local.k8s_node_ips},${local.k8s_lb_ip}" # nodes + LB
  admin_ips       = "10.50.0.1"                                # WireGuard: NAT
}

locals {
  # Reusable Proxmox security groups, shared cluster-wide. Usage: `global_security_groups = ["ssh"]`
  common_security_groups = {
    ssh = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "22", comment = "SSH" },
    ]
    http = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "80", comment = "HTTP" },
    ]
    https = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "443", comment = "HTTPS" },
    ]
    # https://docs.rke2.io/install/requirements#inbound-network-rules
    # Sources follow the RKE2 docs (nodes only; server nodes for etcd). The LB
    # is included where traffic passes through HAProxy, because the control
    # node then sees the LB's IP instead of the client's.

    # Attached to the control node: API access from nodes and the LB.
    k8s_api_cluster = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "6443", source = local.k8s_cluster_ips, comment = "RKE2 API (nodes + LB)" },
    ]
    # Attached to the LB: kubectl/helm/Lens from the admin laptop.
    k8s_api_admin = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "6443", source = local.admin_ips, comment = "RKE2 API (admin)" },
    ]
    k8s_registration = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "9345", source = local.k8s_cluster_ips, comment = "RKE2 Registration" },
    ]
    k8s_kubelet_metric = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "10250", source = local.k8s_node_ips, comment = "RKE2 Metrics" },
    ]
    k8s_etcd_client = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "2379", source = local.k8s_control_ips, comment = "RKE2 etcd client" },
    ]
    k8s_etcd_peer = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "2380", source = local.k8s_control_ips, comment = "RKE2 etcd peer" },
    ]
    k8s_etcd_metrics = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "2381", source = local.k8s_control_ips, comment = "RKE2 etcd metrics" },
    ]
    k8s_nodeport = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "30000:32767", source = local.k8s_node_ips, comment = "K8s NodePort range" },
    ]
    k8s_cni_health = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "9099", source = local.k8s_node_ips, comment = "K8s Canal CNI health check" },
    ]
    k8s_cni_vxlan = [
      { type = "in", action = "ACCEPT", proto = "udp", dport = "8472", source = local.k8s_node_ips, comment = "K8s CNI VXLAN communication" },
    ]
    metallb_memberlist = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "7946", source = local.k8s_node_ips, comment = "MetalLB memberlist" },
      { type = "in", action = "ACCEPT", proto = "udp", dport = "7946", source = local.k8s_node_ips, comment = "MetalLB memberlist" },
    ]
  }
}

resource "proxmox_virtual_environment_cluster_firewall_security_group" "common" {
  for_each = local.common_security_groups

  name    = each.key
  comment = "Managed by Tofu"

  dynamic "rule" {
    for_each = each.value
    content {
      type    = rule.value.type
      action  = rule.value.action
      proto   = try(rule.value.proto, null)
      dport   = try(rule.value.dport, null)
      sport   = try(rule.value.sport, null)
      source  = try(rule.value.source, null)
      dest    = try(rule.value.dest, null)
      comment = try(rule.value.comment, null)
      iface   = try(rule.value.iface, null)
    }
  }
}
