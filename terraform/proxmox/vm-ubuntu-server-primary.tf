resource "proxmox_virtual_environment_vm" "ubuntu_server_primary" {
  name      = "ubuntu-server-primary"
  node_name = var.proxmox_node
  vm_id     = 101

  started = true
  on_boot = true

  startup {
    order    = 2
    up_delay = 120
  }

  acpi = true

  agent {
    enabled = true
  }

  bios = "seabios"

  boot_order = ["scsi0", "net0"]

  cpu {
    cores   = 6
    sockets = 1
    type    = "x86-64-v3"
    numa    = false
  }

  memory {
    dedicated = 12290
  }

  disk {
    datastore_id = "local-lvm"
    # file_id      = "local-lvm:vm-101-disk-0"
    interface = "scsi0"
    iothread  = true
    size      = 378
  }

  scsi_hardware = "virtio-scsi-single"

  network_device {
    bridge      = "vmbr0"
    mac_address = "92:11:B8:CF:BC:ED"
    model       = "virtio"
    firewall    = true
  }

  operating_system {
    type = "l26"
  }

  tags = ["public"]

  initialization {
    user_account {
      keys = local.ssh_public_keys
    }
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      started,
      serial_device
    ]
  }
}
