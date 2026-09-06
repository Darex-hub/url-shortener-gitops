#!/usr/bin/env bash
set -euo pipefail

echo "=== Updating package index ==="
sudo apt-get update -y

echo "=== Installing base packages ==="
sudo apt-get install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release \
  git \
  apt-transport-https

# ---------------------------------------------------------
# Docker
# ---------------------------------------------------------
if ! command -v docker &> /dev/null; then
  echo "=== Installing Docker ==="
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg

  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt-get update -y
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  sudo usermod -aG docker "$USER"
  echo "Docker installed. Log out/in for group membership to take effect."
else
  echo "=== Docker already installed, skipping ==="
fi

# ---------------------------------------------------------
# kubectl
# ---------------------------------------------------------
if ! command -v kubectl &> /dev/null; then
  echo "=== Installing kubectl ==="
  KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
  curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  rm -f kubectl
else
  echo "=== kubectl already installed, skipping ==="
fi

# ---------------------------------------------------------
# K3s
# ---------------------------------------------------------
if ! command -v k3s &> /dev/null; then
  echo "=== Installing K3s ==="
  curl -sfL https://get.k3s.io | sh -

  # Let the current user run kubectl without sudo
  mkdir -p "$HOME/.kube"
  sudo cp /etc/rancher/k3s/k3s.yaml "$HOME/.kube/config"
  sudo chown "$(id -u)":"$(id -g)" "$HOME/.kube/config"
  echo 'export KUBECONFIG=$HOME/.kube/config' >> "$HOME/.bashrc"
else
  echo "=== K3s already installed, skipping ==="
fi

# ---------------------------------------------------------
# Helm
# ---------------------------------------------------------
if ! command -v helm &> /dev/null; then
  echo "=== Installing Helm ==="
  curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
else
  echo "=== Helm already installed, skipping ==="
fi

echo "=== Bootstrap complete ==="
echo "Docker:  $(docker --version 2>/dev/null || echo 'not in this shell yet — relogin')"
echo "kubectl: $(kubectl version --client --short 2>/dev/null || echo kubectl)"
echo "K3s:     $(k3s --version | head -n1)"
echo "Helm:    $(helm version --short)"