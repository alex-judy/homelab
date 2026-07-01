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
    enabled = false
  }

  machine    = "q35"
  bios       = "ovmf"
  boot_order = ["scsi0", "net0"]

  cpu {
    cores   = 4
    sockets = 1
    type    = "x86-64-v3"
    numa    = false
  }

  memory {
    dedicated = 4096
  }

  clone {
    vm_id = proxmox_virtual_environment_vm.ubuntu_template.id
    full  = true
  }

  efi_disk {
    datastore_id = "local-lvm"
    type         = "4m"
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
    interface    = "ide2"

    user_account {
      username = "ubuntu"
      keys     = local.ssh_public_keys
      password = onepassword_item.ubuntu_devops_vm.password
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
