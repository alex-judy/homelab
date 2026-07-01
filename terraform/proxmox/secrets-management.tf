# 1Password vault reference
data "onepassword_vault" "homelab" {
  name = var.op_vault_name
}

# Password for Tailscale LXC
resource "onepassword_item" "tailscale_lxc" {
  vault    = data.onepassword_vault.homelab.uuid
  title    = "Terraform Tailscale LXC"
  category = "login"

  username = "root"

  password_recipe {
    length  = 32
    symbols = true
    digits  = true
  }

  url = "https://10.0.10.10:8006/#v1:0:=qemu/${var.tailscale_vmid}"

  section {
    label = "VM Details"

    field {
      label = "VM Name"
      type  = "STRING"
      value = "tailscale-lxc"
    }

    field {
      label = "VM ID"
      type  = "STRING"
      value = tostring(var.tailscale_vmid)
    }

    field {
      label = "Node"
      type  = "STRING"
      value = var.proxmox_node
    }

    field {
      label = "IP Address"
      type  = "STRING"
      value = "DHCP - check Proxmox"
    }
  }
}

# Password for Forgejo LXC
resource "onepassword_item" "forgejo_lxc" {
  vault    = data.onepassword_vault.homelab.uuid
  title    = "Terraform Forgejo LXC"
  category = "login"

  username = "root"

  password_recipe {
    length  = 32
    symbols = true
    digits  = true
  }

  url = "https://10.0.10.10:8006/#v1:0:=qemu/${var.forgejo_vmid}"

  section {
    label = "VM Details"

    field {
      label = "VM Name"
      type  = "STRING"
      value = "forgejo-lxc"
    }

    field {
      label = "LXC Name"
      type  = "STRING"
      value = "forgejo-lxc"
    }

    field {
      label = "LXC ID"
      type  = "STRING"
      value = tostring(var.forgejo_vmid)
    }

    field {
      label = "Node"
      type  = "STRING"
      value = var.proxmox_node
    }

    field {
      label = "IP Address"
      type  = "STRING"
      value = "DHCP - check Proxmox"
    }
  }
}

# Password for Pterodactyl Panel LXC
resource "onepassword_item" "pterodactyl_panel_lxc" {
  vault    = data.onepassword_vault.homelab.uuid
  title    = "Terraform Pterodactyl Panel LXC"
  category = "login"

  username = "root"

  password_recipe {
    length  = 32
    symbols = true
    digits  = true
  }

  url = "https://10.0.10.10:8006/#v1:0:=qemu/${var.pterodactyl_panel_vmid}"

  section {
    label = "VM Details"

    field {
      label = "VM Name"
      type  = "STRING"
      value = "pterodactyl-panel-lxc"
    }

    field {
      label = "LXC ID"
      type  = "STRING"
      value = tostring(var.pterodactyl_panel_vmid)
    }

    field {
      label = "Node"
      type  = "STRING"
      value = var.proxmox_node
    }

    field {
      label = "IP Address"
      type  = "STRING"
      value = "DHCP - check Proxmox"
    }
  }
}

# Password for Pterodactyl Wing VM
resource "onepassword_item" "pterodactyl_wing_vm" {
  vault    = data.onepassword_vault.homelab.uuid
  title    = "Terraform Pterodactyl Wing VM"
  category = "login"

  username = "root"

  password_recipe {
    length  = 32
    symbols = true
    digits  = true
  }

  url = "https://10.0.10.10:8006/#v1:=qemu/${var.pterodactyl_wing_vmid}"

  section {
    label = "VM Details"

    field {
      label = "VM Name"
      type  = "STRING"
      value = "pterodactyl-wing"
    }

    field {
      label = "VM ID"
      type  = "STRING"
      value = tostring(var.pterodactyl_wing_vmid)
    }

    field {
      label = "Node"
      type  = "STRING"
      value = var.proxmox_node
    }

    field {
      label = "IP Address"
      type  = "STRING"
      value = "DHCP - check Proxmox"
    }
  }
}

# Password for Ubuntu DevOps VM
resource "onepassword_item" "ubuntu_devops_vm" {
  vault    = data.onepassword_vault.homelab.uuid
  title    = "Terraform Ubuntu DevOps VM"
  category = "login"

  username = "ubuntu"

  password_recipe {
    length  = 32
    symbols = true
    digits  = true
  }

  url = "https://10.0.10.10:8006/#v1:=qemu/${var.ubuntu_devops_server_primary_vmid}"

  section {
    label = "VM Details"

    field {
      label = "VM Name"
      type  = "STRING"
      value = "ubuntu-devops"
    }

    field {
      label = "VM ID"
      type  = "STRING"
      value = tostring(var.ubuntu_devops_server_primary_vmid)
    }

    field {
      label = "Node"
      type  = "STRING"
      value = var.proxmox_node
    }

    field {
      label = "IP Address"
      type  = "STRING"
      value = "DHCP - check Proxmox"
    }
  }
}

# Password for Plex LXC
resource "onepassword_item" "plex_lxc" {
  vault    = data.onepassword_vault.homelab.uuid
  title    = "Terraform Plex LXC"
  category = "login"

  username = "root"

  password_recipe {
    length  = 32
    symbols = true
    digits  = true
  }

  url = "https://10.0.10.10:8006/#v1:=qemu/${var.plex_vmid}"

  section {
    label = "LXC Details"

    field {
      label = "LXC Name"
      type  = "STRING"
      value = "plex-lxc"
    }

    field {
      label = "LXC ID"
      type  = "STRING"
      value = tostring(var.plex_vmid)
    }

    field {
      label = "Node"
      type  = "STRING"
      value = var.proxmox_node
    }

    field {
      label = "IP Address"
      type  = "STRING"
      value = tostring(var.plex_ip)
    }
  }
}
