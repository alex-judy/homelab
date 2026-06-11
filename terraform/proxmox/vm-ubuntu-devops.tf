resource "proxmox_virtual_environment_vm" "ubuntu_devops" {
  name      = "ubuntu-devops"
  node_name = var.proxmox_node
  vm_id     = var.ubuntu_devops_server_primary_vmid

  started = true
  on_boot = true

  startup {
    order    = 2
    up_delay = 120
  }

  acpi = true

  agent {
    enabled = false # Note: Ensure qemu-guest-agent is installed on your template image!
  }

  bios       = "seabios"
  boot_order = ["scsi0", "net0"]

  cpu {
    cores   = var.ubuntu_devops_server_primary_cores
    sockets = 1
    type    = "x86-64-v3"
    numa    = false
  }

  memory {
    dedicated = var.ubuntu_devops_server_primary_memory
  }

  clone {
    vm_id = proxmox_virtual_environment_vm.ubuntu_template.id
    full  = true
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    iothread     = true
    size         = var.ubuntu_devops_server_primary_disk
  }

  scsi_hardware = "virtio-scsi-single"

  network_device {
    bridge   = "vmbr0"
    model    = "virtio"
    firewall = true
  }

  operating_system {
    type = "l26"
  }

  initialization {
    datastore_id = "local-lvm"
    interface    = "ide2" # Creates the temporary cloud-init ISO drive

    user_account {
      keys = local.ssh_public_keys
    }

    ip_config {
      ipv4 {
        address = "${var.ubuntu_devops_server_primary_ip}/24"
        gateway = var.network_gateway
      }
    }

    dns {
      servers = split(",", var.dns_servers)
    }

    user_data_file_id = proxmox_virtual_environment_file.ubuntu_devops_cloud_init.id
  }

  tags = ["public", "devops"]

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      started,
      serial_device
    ]
  }
}

resource "proxmox_virtual_environment_file" "ubuntu_devops_cloud_init" {
  content_type = "snippets"
  datastore_id = "local" # 'local' storage typically supports snippets by default in Proxmox
  node_name    = var.proxmox_node

  source_raw {
    file_name = "ubuntu-devops-user-data.yaml"
    data      = <<EOF
#cloud-config
hostname: ubuntu-devops
manage_etc_hosts: true
ssh_pwauth: true

users:
  - name: alex
    groups: sudo
    shell: /bin/bash
    sudo: 'ALL=(ALL) NOPASSWD:ALL'
    ssh_authorized_keys:
      - ${var.ssh_public_key}
    lock_passwd: false

chpasswd:
  list: |
    alex:${onepassword_item.ubuntu_devops_vm.password}
  expire: false
EOF
  }
}
