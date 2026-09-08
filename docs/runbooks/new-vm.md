# Runbook: new Linux VM

1. **Define it in tofu** — copy the template and edit (~15 lines):

   ```bash
   cd tofu
   cp vm_example.tf.disabled vm_myapp.tf
   ```

   Set `name`, `image` (debian/ubuntu), `networks` (VLAN + free IP; add a
   second NIC in `data` only if the VM needs TrueNAS NFS), sizing. Rename the
   module and output blocks to match.

2. **Provision:**

   ```bash
   just plan   # review
   just apply
   ```

3. **Add to the Ansible inventory** — `ansible/inventory/hosts.yml`, under the
   right group(s):

   ```yaml
   docker_hosts:
     hosts:
       myapp:
         ansible_host: 10.50.1.10
   ```

4. **Per-VM config (optional)** — `ansible/inventory/host_vars/myapp.yml`:

   ```yaml
   nfs_mounts:
     - src: "{{ truenas_data_ip }}:/mnt/tank/media"
       path: /mnt/media
   compose_services:
     - whoami
   ```

   Each compose stack needs `ansible/compose/<name>/compose.yml.j2`.

5. **Configure it** (requires SSH access to the VM's VLAN):

   ```bash
   just ping
   just play-limit base myapp
   just play docker        # or: just site
   ```

Removal: delete `vm_myapp.tf`, run `just apply`, remove the inventory entry
and host_vars.

## New Windows VM

Use the commented `windows_vm` block in `vm_example.tf.disabled` — it clones
the hand-built template (see [windows-template.md](windows-template.md)).
Everything inside Windows is configured by hand afterwards.
