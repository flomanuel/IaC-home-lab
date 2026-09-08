# Authentication comes from the environment (loaded from .env by `just`):
#   PROXMOX_VE_ENDPOINT   e.g. https://10.20.0.50:8006/
#   PROXMOX_VE_API_TOKEN  e.g. tofu@pve!tofu=xxxxxxxx-...
# Token creation: docs/runbooks/proxmox-api-token.md

provider "proxmox" {
  insecure = var.proxmox_insecure
  ssh {
    agent = var.ssh_agent
    username = var.ssh_username
    private_key=file(var.ssh_keypath)
  }
}
