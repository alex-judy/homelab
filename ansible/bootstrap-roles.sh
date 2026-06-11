#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if [ ! -f requirements.yml ]; then
  echo "requirements.yml not found in $(pwd)"
  exit 1
fi

ansible-galaxy install -r requirements.yml -p roles

echo "Installed Ansible roles from requirements.yml into $(pwd)/roles"
