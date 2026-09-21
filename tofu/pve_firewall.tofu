locals {
  # Reusable Proxmox security groups, shared cluster-wide. A VM attaches one
  # by key via `global_security_groups = ["ssh"]` (see modules/vm/variables.tf).
  # Add new global groups here.
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
    k8s_api = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "6443", comment = "RKE2 API" },
    ]
    k8s_registration = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "9345", comment = "RKE2 Registration" },
    ]
    k8s_kubelet_metric = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "10250", comment = "RKE2 Metrics" },
    ]
    k8s_etcd_client = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "2379", comment = "RKE2 etcd client" },
    ]
    k8s_etcd_peer = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "2380", comment = "RKE2 etcd peer" },
    ]
    k8s_etcd_metrics = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "2381", comment = "RKE2 etcd metrics" },
    ]
    k8s_nodeport = [
      { type = "in", action = "ACCEPT", proto = "tcp", dport = "30000:32767", comment = "K8s NodePort range" },
    ]
    k8s_cni_health = [
      {
        type   = "in", action = "ACCEPT", proto = "tcp", dport = "9099", comment = "K8s Canal CNI health check",
        source = join(",", [module.k8s-control-1.primary_ip, module.k8s-worker-1.primary_ip, module.k8s-worker-2.primary_ip])
      },
    ]
    k8s_cni_vxlan = [
      {
        type   = "in", action = "ACCEPT", proto = "udp", dport = "8472", comment = "K8s CNI VXLAN communication",
        source = join(",", [module.k8s-control-1.primary_ip, module.k8s-worker-1.primary_ip, module.k8s-worker-2.primary_ip])
      },
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
