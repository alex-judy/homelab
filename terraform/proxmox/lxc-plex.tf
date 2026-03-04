resource "proxmox_virtual_environment_container" "plex" {
  vm_id     = var.plex_vmid
  node_name = var.proxmox_node

  operating_system {
    template_file_id = var.lxc_template
    type             = "ubuntu"
  }


  disk {
    datastore_id = var.lxc_storage
    size         = 32
  }

  cpu {
    cores = 4
  }

  memory {
    dedicated = 4096
  }

  network_interface {
    name   = "eth0"
    bridge = var.network_bridge
  }

  initialization {
    hostname = "plex"

    ip_config {
      ipv4 {
        address = "${var.plex_ip}/24" # Add CIDR notation
        gateway = var.network_gateway
      }
    }

    dns {
      servers = split(",", var.dns_servers)
    }

    user_account {
      keys     = [var.ssh_public_key]
      password = onepassword_item.plex_lxc.password
    }
  }

  features {
    mount = ["nfs"]
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
