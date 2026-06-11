# Download the Home Assistant OS disk image for x86_64 and use it as the VM disk.
# The project no longer publishes a bootable ISO; the generic img/qcow2
# artifact is what you want for KVM/Proxmox.

resource "proxmox_virtual_environment_download_file" "haos-image" {
  content_type            = "iso"
  datastore_id            = "local"
  node_name               = var.proxmox_node
  decompression_algorithm = "zst"
  overwrite               = true

  url       = "https://github.com/home-assistant/operating-system/releases/download/17.1/haos_ova-17.1.qcow2.xz"
  file_name = "haos_ova-17.1.img"
}

resource "proxmox_virtual_environment_vm" "home-assistant" {
  name      = "home-assistant"
  node_name = var.proxmox_node
  vm_id     = var.homeassistant_vmid

  on_boot = true

  startup {
    order    = 3
    up_delay = 60
  }

  acpi          = true
  machine       = "q35"
  bios          = "ovmf"
  tablet_device = false

  agent {
    enabled = true
  }

  cpu {
    cores   = 2
    sockets = 1
  }

  memory { dedicated = 4096 }

  efi_disk {
    datastore_id      = "local-lvm"
    file_format       = "raw"
    type              = "4m"
    pre_enrolled_keys = false
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.haos-image.id
    interface    = "scsi0"
    discard      = "on" # Matches the 'Optimizations' section in HA docs
    ssd          = true
    size         = 32 # HAOS image is small, but 32GB+ is recommended for logs/history
  }

  scsi_hardware = "virtio-scsi-pci"

  serial_device {
    device = "socket"
  }

  network_device {
    bridge   = var.network_bridge
    model    = "virtio"
    firewall = true
  }

  operating_system {
    type = "l26"
  }

  initialization {
    user_account {
      keys = local.ssh_public_keys
    }
  }

  lifecycle {
    ignore_changes = [
      description,
      vga,
      usb,
      boot_order,
      disk[0].file_id,
    ]
  }
}
