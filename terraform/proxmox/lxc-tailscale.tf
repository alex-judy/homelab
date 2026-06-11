resource "proxmox_virtual_environment_container" "tailscale" {
  vm_id        = 100
  node_name    = var.proxmox_node
  unprivileged = false

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

  device_passthrough {
    path = "/dev/net/tun"
  }

  initialization {
    hostname = "tailscale"

    ip_config {
      ipv4 {
        address = "${var.tailscale_ip}/24" # Add CIDR notation
        gateway = var.network_gateway
      }
    }

    dns {
      servers = split(",", var.dns_servers)
    }

    user_account {
      keys     = local.ssh_public_keys
      password = onepassword_item.tailscale_lxc.password
    }
  }

  features {
    keyctl  = true
    nesting = true
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
