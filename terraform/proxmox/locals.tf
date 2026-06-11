locals {
  ssh_public_keys = [
    trimspace(file("~/.ssh/id_ed25519.pub")),
    trimspace(var.runner_public_key) # can reference variables
  ]

  environment = "homelab"

  common_tags = {
    managed_by  = "terraform"
    environment = local.environment # can reference other locals
  }
}
