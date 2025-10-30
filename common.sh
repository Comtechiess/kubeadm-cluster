#!/bin/bash
#
# Common setup for all servers (Control Plane and Nodes)
set -euxo pipefail

# Kubernetes Versioning - Using stable versions
KUBERNETES_VERSION=v1.33
KUBERNETES_INSTALL_VERSION=1.33.2-1.1
CRIO_VERSION=v1.33

# Disable swap
swapoff -a
(crontab -l 2>/dev/null; echo "@reboot /sbin/swapoff -a") | crontab - || true

# Load required kernel modules
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

# Apply sysctl settings
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sysctl --system

# Update base packages
apt-get update -y
apt-get install -y apt-transport-https ca-certificates curl gpg software-properties-common jq

# Install CRI-O Runtime
mkdir -p /etc/apt/keyrings

# Add CRI-O key and repo
curl -fsSL https://download.opensuse.org/repositories/isv:/cri-o:/stable:/$CRIO_VERSION/deb/Release.key |
    gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://download.opensuse.org/repositories/isv:/cri-o:/stable:/$CRIO_VERSION/deb/ /" |
    tee /etc/apt/sources.list.d/cri-o.list

sudo apt-get update -y
sudo apt-get install -y cri-o
sudo systemctl daemon-reload
sudo systemctl enable crio --now

echo "CRI runtime installed successfully"

# Install Kubernetes components
curl -fsSL https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Add the Kubernetes APT repository 
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update package index and install Kubernetes tools
sudo apt-get update
sudo apt-get install -y kubelet=$KUBERNETES_INSTALL_VERSION kubeadm=$KUBERNETES_INSTALL_VERSION kubectl=$KUBERNETES_INSTALL_VERSION

# Prevent automatic updates of Kubernetes components
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable --now kubelet
