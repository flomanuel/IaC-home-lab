set dotenv-load

tofu_dir := "tofu"
ansible_dir := "ansible"

default:
    @just --list

# ---------- OpenTofu ----------

# Initialize providers/backend (run after each backend change)
[group('tofu')]
init:
    cd {{ tofu_dir }} && tofu init

[group('tofu')]
plan:
    cd {{ tofu_dir }} && tofu plan

[group('tofu')]
apply:
    cd {{ tofu_dir }} && tofu apply

# Destroy EVERYTHING managed by tofu — asks for confirmation
[group('tofu')]
destroy:
    cd {{ tofu_dir }} && tofu destroy

[group('tofu')]
fmt:
    cd {{ tofu_dir }} && tofu fmt -recursive

[group('tofu')]
validate:
    cd {{ tofu_dir }} && tofu validate

[group('tofu')]
output:
    cd {{ tofu_dir }} && tofu output

# ---------- Ansible ----------

# Install required Ansible collections
[group('ansible')]
deps:
    cd {{ ansible_dir }} && ansible-galaxy collection install -r requirements.yml

[group('ansible')]
ping:
    cd {{ ansible_dir }} && ansible linux -m ping

# Run every playbook
[group('ansible')]
site:
    cd {{ ansible_dir }} && ansible-playbook playbooks/site.yml

# Run a single playbook, e.g. `just play docker`
[group('ansible')]
play pb:
    cd {{ ansible_dir }} && ansible-playbook playbooks/{{ pb }}.yml

# Limit a playbook to one host, e.g. `just play-limit base myapp`
[group('ansible')]
play-limit pb host:
    cd {{ ansible_dir }} && ansible-playbook playbooks/{{ pb }}.yml --limit {{ host }}

# ---------- Checks ----------

# Broken. Todo: fix
[group('ansible')]
[group('tofu')]
lint:
    cd {{ tofu_dir }} && tofu fmt -check -recursive && tofu validate
    cd {{ ansible_dir }} && ansible-lint
