FROM ubuntu:24.04 AS builder

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

ARG HADOLINT_VERSION=2.14.0
RUN curl -fsSL -o hadolint \
    "https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-Linux-x86_64" \
    && chmod +x hadolint

FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    gnupg \
    lsb-release \
    openssh-client \
    nodejs \
    npm \
    python3 \
    python3-pip \
    python3-venv \
    rsync \
    shellcheck \
    software-properties-common \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN apt-add-repository --yes --update ppa:ansible/ansible && \
    curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    > /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && apt-get install -y --no-install-recommends \
    ansible \
    terraform \
    && rm -rf /var/lib/apt/lists/*

RUN curl -Ls --tlsv1.2 --proto "=https" --retry 3 https://cli.doppler.com/install.sh | sh

COPY --from=builder /hadolint /usr/local/bin/hadolint

RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir --upgrade pip && \
    /opt/venv/bin/pip install --no-cache-dir \
      ansible-core==2.21.1 \
      ansible-lint==26.4.0 \
      yamllint \
      checkov \
      ggshield \
      pip-audit

ENV PATH="/opt/venv/bin:${PATH}"
WORKDIR /workspace

RUN ansible --version && \
    terraform --version && \
    doppler --version && \
    ssh -V && \
    rsync --version && \
    hadolint --version