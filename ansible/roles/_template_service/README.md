# _template_service

Copy-me skeleton for a bare systemd service role:

1. `cp -r _template_service <service_name>` (drop the underscore)
2. Fill in the TODOs in `tasks/main.yml` and `defaults/main.yml`
3. Add the role to a playbook (or a new `playbooks/<service>.yml` targeting
   `svc_hosts`), and the target VM to the `svc_hosts` group in the inventory
