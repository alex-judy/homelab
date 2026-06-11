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

WORKDIR /workspace