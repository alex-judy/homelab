resource "proxmox_virtual_environment_vm" "pterodactyl_wing" {
  vm_id     = var.pterodactyl_wing_vmid
  node_name = var.proxmox_node

  name        = "pterodactyl-wing"
  description = "Managed by Terraform"

  machine = "q35"
  bios    = "ovmf"
  started = true

  cpu {
    cores = 4
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = 12288
  }

  agent {
    enabled = true
  }

  efi_disk {
    datastore_id = var.lxc_storage
    type         = "4m"
  }

  disk {
    datastore_id = var.lxc_storage
    file_id      = proxmox_virtual_environment_download_file.ubuntu_cloud_image.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 50
  }

  network_device {
    bridge = var.network_bridge
    model  = "virtio"
  }

  initialization {

    user_account {
      keys = local.ssh_public_keys
    }

    ip_config {
      ipv4 {
        address = "${var.pterodactyl_wing_ip}/24"
        gateway = var.network_gateway
      }
    }

    dns {
      servers = split(",", var.dns_servers)
    }

    user_data_file_id = proxmox_virtual_environment_file.cloud_init_wings.id
  }

  startup {
    order = 1
  }

  lifecycle {
    ignore_changes = [
      description,
      initialization,
      disk[0].file_id,
      disk[0].file_format,
      disk[0].path_in_datastore,
      network_device[0].mac_address,
      boot_order,
      vga,
      cpu[0].units,
    ]
  }
}

resource "proxmox_virtual_environment_file" "cloud_init_wings" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.proxmox_node

  source_raw {
    data      = <<-EOF
      #cloud-config
      users:
        - name: ubuntu
          groups: docker
          sudo: ALL=(ALL) NOPASSWD:ALL
          shell: /bin/bash
          passwd: ${onepassword_item.pterodactyl_wing_vm.password}
      packages:
        - qemu-guest-agent
        - docker.io
        - htop
        - vim
      runcmd:
        - systemctl enable qemu-guest-agent
        - systemctl start qemu-guest-agent
        - systemctl enable docker
        - systemctl start docker
        - mkdir -p /etc/pterodactyl
        - curl -L -o /usr/local/bin/wings "https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_amd64"
        - chmod u+x /usr/local/bin/wings
    EOF
    file_name = "wings-cloud-init.yaml"
  }
}
