terraform {
  required_version = ">= 1.0"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.89.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    onepassword = {
      source  = "1Password/onepassword"
      version = "~> 2.1"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox_api_url
  # api_token = var.proxmox_api_token
  username = var.proxmox_username
  password = var.proxmox_password
  insecure = var.proxmox_tls_insecure
  ssh {
    agent    = true
    username = "root"
  }
}

provider "onepassword" {
  service_account_token = var.op_service_account_token
  # service_account_token pulled from OP_SERVICE_ACCOUNT_TOKEN env var automatically
}
