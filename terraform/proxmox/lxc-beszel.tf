resource "proxmox_virtual_environment_container" "beszel" {
  vm_id     = var.beszel_vmid
  node_name = var.proxmox_node

  operating_system {
    template_file_id = var.lxc_template
    type             = "ubuntu"
  }

  disk {
    datastore_id = var.lxc_storage
    size         = 16
  }

  cpu {
    cores = 1
  }

  memory {
    dedicated = 1024
  }

  network_interface {
    name   = "eth0"
    bridge = var.network_bridge
  }

  initialization {
    hostname = "beszel"

    ip_config {
      ipv4 {
        address = "${var.beszel_ip}/24" # Add CIDR notation
        gateway = var.network_gateway
      }
    }

    dns {
      servers = split(",", var.dns_servers)
    }

    user_account {
      keys     = local.ssh_public_keys
      password = onepassword_item.beszel_lxc.password
    }
  }

  startup {
    order = 1
  }

  lifecycle {
    ignore_changes = [
      description,
      initialization,
    ]
  }
}
