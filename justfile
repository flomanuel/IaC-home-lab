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

# Run every playbook, e.g. `just site --check --diff`
[group('ansible')]
site *args:
    cd {{ ansible_dir }} && ansible-playbook playbooks/site.yml {{ args }}

# Run a single playbook, e.g. `just play truenas_s3 --limit lxc-1 --tags seaweedfs`
[group('ansible')]
play pb *args:
    cd {{ ansible_dir }} && ansible-playbook playbooks/{{ pb }}.yml {{ args }}

# List the playbooks for `just play`
[group('ansible')]
playbooks:
    @ls {{ ansible_dir }}/playbooks | sed 's/\.yml$//' | grep -v '^site$'

# ---------- Checks ----------

# Broken. Todo: fix
[group('ansible')]
[group('tofu')]
lint:
    cd {{ tofu_dir }} && tofu fmt -check -recursive && tofu validate
    cd {{ ansible_dir }} && ansible-lint
