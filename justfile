set dotenv-load

tofu_dir := "tofu"
ansible_dir := "ansible"

default:
    @just --list

# ---------- OpenTofu ----------

# Initialize providers/backend (run after each backend change)
init:
    cd {{ tofu_dir }} && tofu init

plan:
    cd {{ tofu_dir }} && tofu plan

apply:
    cd {{ tofu_dir }} && tofu apply

# Destroy EVERYTHING managed by tofu — asks for confirmation
destroy:
    cd {{ tofu_dir }} && tofu destroy

fmt:
    cd {{ tofu_dir }} && tofu fmt -recursive

validate:
    cd {{ tofu_dir }} && tofu validate

output:
    cd {{ tofu_dir }} && tofu output

# ---------- Ansible ----------

# Install required Ansible collections
deps:
    cd {{ ansible_dir }} && ansible-galaxy collection install -r requirements.yml

ping:
    cd {{ ansible_dir }} && ansible linux -m ping

# Run every playbook
site:
    cd {{ ansible_dir }} && ansible-playbook playbooks/site.yml

# Run a single playbook, e.g. `just play docker`
play pb:
    cd {{ ansible_dir }} && ansible-playbook playbooks/{{ pb }}.yml

# Limit a playbook to one host, e.g. `just play-limit base myapp`
play-limit pb host:
    cd {{ ansible_dir }} && ansible-playbook playbooks/{{ pb }}.yml --limit {{ host }}

# ---------- Checks ----------

# Broken. Todo: fix
lint:
    cd {{ tofu_dir }} && tofu fmt -check -recursive && tofu validate
    cd {{ ansible_dir }} && ansible-lint
