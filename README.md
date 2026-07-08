# homelab

A self-hosted homelab repository for provisioning and deploying Proxmox infrastructure, Ubuntu Docker hosts, and service stacks using Ansible, Terraform, and Docker Compose.

## Repository layout

- `ansible/`
  - `playbooks/` — Ansible playbooks for provisioning VMs, LXC containers, and Docker hosts.
  - `inventory/` — Ansible inventory and group variables for Proxmox hosts, VMs, and containers.
  - `requirements.yml` — Ansible roles and collections dependencies.
  - `bootstrap-roles.sh` — helper script to install required Ansible roles.
- `docker/`
  - `ubuntu-primary/compose-files/` — Docker Compose stacks for the primary Ubuntu Docker host.
  - `ubuntu-devops/compose-files/` — Docker Compose stacks for the devops host.
- `terraform/proxmox/` — Proxmox infrastructure provisioning for LXC containers and VMs.
- `.forgejo/workflows/` — Forgejo CI/CD workflows for security scanning, deployment, and CI image builds.
- `SECURITY.md` — security policy and reporting information.

## What this repo manages

- Proxmox VM and LXC provisioning via Terraform.
- Host and stack deployment via Ansible playbooks.
- Docker Compose-based service stacks for production and devops hosts.
- CI and security automation through Forgejo workflows.

## Key components

### Ansible

Key playbooks:
- `ansible/playbooks/vm-ubuntu-primary.yml` — deploys Ubuntu primary Docker host and synchronizes `docker/ubuntu-primary/` stacks.
- `ansible/playbooks/vm-ubuntu-devops.yml` — deploys Ubuntu devops host and synchronizes `docker/ubuntu-devops/` stacks.
- `ansible/playbooks/lxc-tailscale.yml` — configures Tailscale LXC container.
- `ansible/playbooks/lxc-plex.yml` — configures Plex container.
- `ansible/playbooks/lxc-pterodactyl-panel.yml` — configures Pterodactyl panel container.

Inventory groups defined in `ansible/inventory/hosts.yml`:
- `proxmox` — Proxmox host(s) such as `heimdall`.
- `vms` — Ubuntu VM hosts including `ubuntu-server-primary`, `ubuntu-devops`, `home-assistant`, and `pterodactyl-wing`.
- `lxc_containers` — LXC containers such as `tailscale`, `plex`, and `pterodactyl-panel`.
- `media_servers` — media-related hosts and variables.

### Docker stacks

Ubuntu Primary stacks are organized under `docker/ubuntu-primary/compose-files/` by function:
- `bittor/`
- `indexers/`
- `management/`
- `media/`
- `monitoring/`
- `network/`
- `other/`
- `pvr/`
- `security/`
- `utility/`

Ubuntu Devops stacks are organized under `docker/ubuntu-devops/compose-files/`:
- `forgejo/`
- `komodo/`
- `runner/`

These stacks are deployed by the corresponding Ansible playbooks and are typically environment-variable driven.

### Terraform

The `terraform/proxmox/` folder contains Proxmox provisioning configuration for LXC containers and QEMU VMs.

Important Terraform files:
- `main.tf` — provider configuration for Proxmox and OnePassword.
- `variables.tf` — shared variable definitions.
- `terraform.tfvars` — local values for provisioning.
- `lxc-plex.tf`, `lxc-pterodactyl-panel.tf`, `lxc-tailscale.tf` — LXC container resources.
- `vm-homeassistant.tf`, `vm-pterodactyl-wing.tf`, `vm-ubuntu-devops.tf`, `vm-ubuntu-server-primary.tf` — VM resources.
- `vm-truenas.tf` — TrueNAS-related provisioning or storage integration.

### CI / Forgejo workflows

Workflow files in `.forgejo/workflows/`:
- `security-scans.yml` — secrets, Ansible lint, YAML lint, Terraform security scans, and Dockerfile lint.
- `build-ci-image.yml` — builds and pushes the CI tools image used by workflows.
- `deploy-devops.yml` — deploys the devops host when `docker/ubuntu-devops/` changes.
- `deploy-primary.yml` — deploys the primary host when `docker/ubuntu-primary/` changes.
- `renovate.yml` — dependency update automation.

## Getting started

1. Install Ansible role dependencies:

   ```bash
   cd homelab
   ansible-galaxy install -r ansible/requirements.yml -p ./.ansible/roles
   ```

2. Run an Ansible playbook against inventory:

   ```bash
   ansible-playbook ansible/playbooks/vm-ubuntu-primary.yml -i ansible/inventory/hosts.yml
   ```

3. For Terraform provisioning, initialize and apply from `terraform/proxmox/`:

   ```bash
   cd terraform/proxmox
   terraform init
   terraform apply
   ```

## Notes

- This repository is designed around Forgejo-native CI automation and security checks.
- `ansible/ansible.cfg` configures inventory, roles, collections, and SSH/privilege escalation settings.
- Docker stacks are synchronized from the repository into remote hosts and deployed with `docker compose up -d`.

## Security

See `SECURITY.md` for security reporting, vulnerability handling, and responsible disclosure.
