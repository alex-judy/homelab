# homelab

This repository uses Forgejo workflows under `.forgejo/workflows`.

## Security workflows

- `.forgejo/workflows/security-scans.yml` — runs secret scanning, Ansible/YAML/workflow linting, Terraform security scans, and Dockerfile linting.
- `.forgejo/workflows/codeql-scans.yml` — runs CodeQL analysis for Python and HCL.

## Notes

- The repository is configured for Forgejo native CI and security automation.
