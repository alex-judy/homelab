resource "proxmox_virtual_environment_container" "rustdesk" {
  vm_id     = var.rustdesk_vmid
  node_name = var.proxmox_node

  operating_system {
    template_file_id = var.lxc_template
    type             = "ubuntu"
  }

  disk {
    datastore_id = var.lxc_storage
    size         = 8
  }

  cpu {
    cores = 1
  }

  memory {
    dedicated = 512
  }

  network_interface {
    name   = "eth0"
    bridge = var.network_bridge
  }

  initialization {
    hostname = "rustdesk"

    ip_config {
      ipv4 {
        address = "${var.rustdesk_ip}/24" # Add CIDR notation
        gateway = var.network_gateway
      }
    }

    dns {
      servers = split(",", var.dns_servers)
    }

    user_account {
      keys     = [var.ssh_public_key]
      password = onepassword_item.tailscale_lxc.password
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
