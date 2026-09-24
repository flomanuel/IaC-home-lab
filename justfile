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
plan-out:
    cd {{ tofu_dir }} && tofu plan -out tfplan

[group('tofu')]
apply:
    cd {{ tofu_dir }} && tofu apply


default := ' '
# Destroy the given resources (ALL if none are given) managed by tofu.
[group('tofu')]
destroy resources=default:
    cd {{ tofu_dir }} && tofu destroy {{ resources }}


[group('tofu')]
fmt:
    cd {{ tofu_dir }} && tofu fmt -recursive

[group('tofu')]
validate:
    cd {{ tofu_dir }} && tofu validate

[group('tofu')]
output:
    cd {{ tofu_dir }} && tofu output

[group('tofu')]
import res id:
    cd {{ tofu_dir }} && tofu import {{res}} {{id}}

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
