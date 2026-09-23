locals {
  # Firewall sources for the K8s rules below. Add new nodes here.
  k8s_control_ips = join(",", [module.k8s-control-1.primary_ip, "127.0.0.1"])
  k8s_node_ips = join(",", [
    module.k8s-control-1.primary_ip,
    module.k8s-worker-1.primary_ip,
    module.k8s-worker-2.primary_ip,
    module.k8s-worker-3.primary_ip,
    "127.0.0.1"
  ])
  admin_ips = "10.50.0.1" # WireGuard: NAT
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
    # https://docs.k3s.io/installation/requirements#inbound-rules-for-k3s-nodes
    # Sources follow the K3s docs (nodes only; server nodes for etcd). The
    # kube-vip control-plane VIP (ARP mode) moves between the server nodes;
    # the rules below set no `dest`, so they also cover traffic to the VIP.

    # Attached to the server nodes: API access and agent registration from nodes.
    k8s_api_cluster = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "6443", source = local.k8s_node_ips, comment = "K3s API + registration (nodes)" },
    ]
    # Attached to the server nodes: kubectl/helm/Lens from the admin laptop.
    k8s_api_admin = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "6443", source = local.admin_ips, comment = "K3s API (admin)" },
    ]
    k8s_kubelet_metric = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "10250", source = local.k8s_node_ips, comment = "Kubelet metrics" },
    ]
    k8s_etcd_client = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "2379", source = local.k8s_control_ips, comment = "K3s etcd client" },
    ]
    k8s_etcd_peer = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "2380", source = local.k8s_control_ips, comment = "K3s etcd peer" },
    ]
    k8s_etcd_metrics = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "2381", source = local.k8s_control_ips, comment = "K3s etcd metrics" },
    ]
    k8s_nodeport = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "30000:32767", source = local.k8s_node_ips, comment = "K8s NodePort range" },
    ]
    k8s_cni_vxlan = [
      { type = "in", action = "ACCEPT", proto = "udp", dport = "8472", source = local.k8s_node_ips, comment = "K3s flannel VXLAN" },
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
