FROM ubuntu:24.04

# Avoid interactive prompts during package install
ENV DEBIAN_FRONTEND=noninteractive

# Install base dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    gnupg \
    lsb-release \
    openssh-client \
    nodejs \
    npm \
    python3 \
    python3-pip \
    rsync \
    software-properties-common \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install Ansible
RUN apt-add-repository --yes --update ppa:ansible/ansible && \
    apt-get install -y ansible && \
    rm -rf /var/lib/apt/lists/*

# Install Terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    > /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && apt-get install -y terraform && \
    rm -rf /var/lib/apt/lists/*

# Install Doppler CLI
RUN curl -Ls --tlsv1.2 --proto "=https" --retry 3 \
    https://cli.doppler.com/install.sh | sh

# Verify installs
RUN ansible --version && \
    terraform --version && \
    doppler --version && \
    ssh -V && \
    rsync --version

# Install scanner dependencies
RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install --no-cache-dir ansible-lint yamllint checkov ggshield pip-audit && \
    curl -L https://github.com/aquasecurity/tfsec/releases/latest/download/tfsec-linux-amd64 -o /usr/local/bin/tfsec && \
    chmod +x /usr/local/bin/tfsec && \
    curl -L https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64 -o /usr/local/bin/hadolint && \
    chmod +x /usr/local/bin/hadolint && \
    curl -L https://github.com/rhysd/actionlint/releases/latest/download/actionlint_linux_amd64.tar.gz | tar xz -C /usr/local/bin actionlint && \
    curl -L https://github.com/github/codeql-action/releases/latest/download/codeql-bundle-linux64.zip -o /tmp/codeql.zip && \
    unzip -q /tmp/codeql.zip -d /opt/codeql && \
    ln -s /opt/codeql/codeql /usr/local/bin/codeql

WORKDIR /workspace