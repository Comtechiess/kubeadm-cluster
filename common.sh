#!/bin/bash
#
# Common setup for all servers (Control Plane and Nodes)
set -euxo pipefail

# Kubernetes Versioning - Using stable versions
KUBERNETES_VERSION=v1.34
KUBERNETES_INSTALL_VERSION=1.34.2-1.1
CONTAINERD_VERSION=2.1.4

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

# Install Contained Runtime
wget https://github.com/containerd/containerd/releases/download/v${CONTAINERD_VERSION}/containerd-${CONTAINERD_VERSION}-linux-amd64.tar.gz
tar Cxzvf /usr/local containerd-${CONTAINERD_VERSION}-linux-amd64.tar.gz
rm -f containerd-${CONTAINERD_VERSION}-linux-amd64.tar.gz

# Install runc
RUNC_VERSION=$(curl -s https://api.github.com/repos/opencontainers/runc/releases/latest | jq -r '.tag_name')
wget https://github.com/opencontainers/runc/releases/download/${RUNC_VERSION}/runc.amd64
install -m 755 runc.amd64 /usr/local/sbin/runc
rm -f runc.amd64

# Configure containerd
mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

# Install systemd service
mkdir -p /usr/lib/systemd/system
wget -O /usr/lib/systemd/system/containerd.service https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
systemctl daemon-reload
systemctl enable containerd --now

echo "Containerd runtime installed successfully"

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
