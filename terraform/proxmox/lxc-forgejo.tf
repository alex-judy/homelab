resource "proxmox_virtual_environment_container" "forgejo" {
  vm_id     = var.forgejo_vmid
  node_name = var.proxmox_node

  operating_system {
    template_file_id = var.lxc_template
    type             = "ubuntu"
  }

  disk {
    datastore_id = var.lxc_storage
    size         = 10
  }

  cpu {
    cores = 2
  }

  memory {
    dedicated = 2048
  }

  network_interface {
    name   = "eth0"
    bridge = var.network_bridge
  }

  initialization {
    hostname = "forgejo"

    ip_config {
      ipv4 {
        address = "${var.forgejo_ip}/24" # Add CIDR notation
        gateway = var.network_gateway
      }
    }

    dns {
      servers = split(",", var.dns_servers)
    }

    user_account {
      keys     = local.ssh_public_keys
      password = onepassword_item.forgejo_lxc.password
    }
  }

  features {
    nesting = false
    fuse    = false
    keyctl  = false
    mount   = []
  }

  startup {
    order = 1
  }

  lifecycle {
    ignore_changes = [
      description,
      initialization
    ]
  }
}
