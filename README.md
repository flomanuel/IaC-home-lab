# Home Lab IaC Project

Infrastructure-as-code for the homelab: **OpenTofu** provisions VMs on the
Proxmox node (`10.20.0.50`), **Ansible** configures the Linux guests. The
Proxmox host itself and the Windows VMs are hand-managed by design.

Network details: [docs/topology.md](docs/topology.md).

## Layout

```
tofu/                  OpenTofu root module (one state)
  vm_*.tf              one file per VM — based on vm_example.tf.disabled
  locals.tf            VLAN map + shared settings (local.common)
  images.tf            Debian/Ubuntu cloud image downloads
  modules/vm           Linux VM (cloud-init)
  modules/windows_vm   Windows VM (clone of hand-built template)
ansible/
  inventory/hosts.yml  static inventory (groups: docker_hosts, svc_hosts, k3s_*)
  playbooks/           site, base, docker, k3s
  roles/               base, nfs_mounts, docker, compose_service, k3s_*, _template_service
  compose/<name>/      management plane only: dockhand (debian-01), hawser agent (other docker hosts)
stacks/<name>/         compose stacks, deployed by Dockhand as git stacks (docs/runbooks/dockhand.md)
stacks/backup/<host>/  offen/docker-volume-backup, one stack per docker host
docs/runbooks/         step-by-step guides (new VM, Dockhand, API token, vmbr1, Windows template)
justfile               front door: just --list
```

## Daily use

New VM: [docs/runbooks/new-vm.md](docs/runbooks/new-vm.md). In short: copy
`tofu/vm_example.tf.disabled`, `just apply`, add to the inventory, run the
playbooks.

```
just plan / apply      OpenTofu
just ping / site       Ansible
just play <playbook>   single playbook
```

## Roadmap

- Secrets to self-hosted [Infisical](https://infisical.com): replaces `.env`
and `secrets.yml` (Infisical tofu provider + Ansible lookup exist).
