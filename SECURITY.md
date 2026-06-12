# Security Policy

## What we scan
- Secret scanning on push and pull requests
- Infrastructure-as-code scanning for Terraform
- Ansible and YAML linting
- Dockerfile linting
- Dependency review for workflow dependencies

## Recommended controls
- Protect `main` with required pull requests, status checks, and review approvals
- Require signed commits when supported by your forge
- Keep secrets out of git and avoid committed Terraform state files

## Notes
This repository also uses a dedicated CI tools image for workflow execution, and security check automation should run on every pull request and main branch push.

## CodeQL
- CodeQL analysis is run from a dedicated Forgejo workflow using the CodeQL bundle.
- It analyzes Python and HCL source.
