# One-time: API token for OpenTofu

On the Proxmox host (root shell):

```bash
pveum user add tofu@pam
pveum aclmod / -user tofu@pam -role Administrator
pveum user token add tofu@pam tofu --privsep 0
```

The last command prints the token secret **once**. Put it into `.env`:

```
PROXMOX_VE_API_TOKEN=tofu@pve!tofu=<the-printed-secret>
```

`Administrator` is the pragmatic single-admin-homelab choice. A least-privilege
custom role is possible — the bpg provider docs list the required privileges:
https://registry.terraform.io/providers/bpg/proxmox/latest/docs#api-token-authentication
