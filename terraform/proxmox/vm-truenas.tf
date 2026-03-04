resource "proxmox_virtual_environment_vm" "truenas" {
  name      = "truenas"
  node_name = "heimdall"
  vm_id     = 102

  started       = true
  on_boot       = true
  scsi_hardware = "virtio-scsi-single"

  tags = ["internal"]

  # Startup order
  startup {
    order      = 1
    up_delay   = 0
    down_delay = 0
  }

  agent {
    enabled = false # TrueNAS doesn't typically have guest agent
  }

  cpu {
    cores   = 4
    sockets = 1
    type    = "host"
  }

  memory {
    dedicated = 32000 # 32GB
  }

  # Boot/OS disk (virtual disk on local-lvm)
  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = 32
    iothread     = true
    discard      = "on"
  }

  # Physical disk passthroughs - these are managed outside Terraform
  # scsi1: /dev/disk/by-id/ata-WDC_WD181KFGX-68AFPN0_5BH2LPKR
  # scsi2: /dev/disk/by-id/ata-WDC_WD181KFGX-68AFPN0_4MH2DXAV
  # scsi3: /dev/disk/by-id/usb-Sabrent_enclosure_012345679149-0:0
  # scsi4: /dev/disk/by-id/ata-WDC_WD181KFGX-68CKWN0_PNG28XTP
  # scsi5: /dev/disk/by-id/ata-WDC_WD181KFGX-68CKWN0_T0G0PJLF

  network_device {
    bridge      = "vmbr0"
    model       = "virtio"
    mac_address = "32:7F:C5:0A:45:C0"
    firewall    = true
  }

  operating_system {
    type = "l26"
  }

  # Critical: Prevent Terraform from managing physical disk passthroughs
  lifecycle {
    prevent_destroy = true

    ignore_changes = [
      disk,
      usb,
      hostpci,
      cpu[0].type,
      startup[0].down_delay,
      network_device[0].mac_address,
      agent,
      description,
      tags,
    ]
  }
}

# Store TrueNAS credentials in 1Password
resource "onepassword_item" "truenas_admin" {
  vault    = data.onepassword_vault.homelab.uuid
  title    = "TrueNAS Admin - ${proxmox_virtual_environment_vm.truenas.name}"
  category = "login"

  username = "admin"
  url      = "http://${try(proxmox_virtual_environment_vm.truenas.ipv4_addresses[1][0], "check-proxmox-for-ip")}"

  section {
    label = "VM Details"

    field {
      label = "VM ID"
      type  = "STRING"
      value = tostring(proxmox_virtual_environment_vm.truenas.vm_id)
    }

    field {
      label = "Node"
      type  = "STRING"
      value = proxmox_virtual_environment_vm.truenas.node_name
    }
  }

  section {
    label = "Physical Disks"

    field {
      label = "Disk 1"
      type  = "STRING"
      value = "WDC 18TB (5BH2LPKR) - scsi1"
    }

    field {
      label = "Disk 2"
      type  = "STRING"
      value = "WDC 18TB (4MH2DXAV) - scsi2"
    }

    field {
      label = "Disk 3"
      type  = "STRING"
      value = "Sabrent USB - scsi3"
    }

    field {
      label = "Disk 4"
      type  = "STRING"
      value = "WDC 18TB (PNG28XTP) - scsi4"
    }

    field {
      label = "Disk 5"
      type  = "STRING"
      value = "WDC 18TB (T0G0PJLF) - scsi5"
    }
  }
}

output "truenas_web_url" {
  description = "TrueNAS web interface URL"
  value       = "http://${try(proxmox_virtual_environment_vm.truenas.ipv4_addresses[1][0], "IP not available - check Proxmox")}"
}

output "truenas_vm_id" {
  description = "TrueNAS VM ID"
  value       = proxmox_virtual_environment_vm.truenas.vm_id
}