# kubeadm-cluster
A complete guide to setting up Kubernetes cluster using Vagrant, VirtualBox, and CRI-O runtime. This configuration creates a multi-node cluster with 1 control plane and 2 worker nodes.
# Prerequisites 
- Vagrant 
- VirtualBox 
- Minimum 8GB RAM available for VMs
- 20GB free disk space
# Cluster Architecture
<table class="bg-bg-100 min-w-full border-separate border-spacing-0 text-sm leading-[1.88888] whitespace-normal"><thead class="border-b-border-100/50 border-b-[0.5px] text-left"><tr class="[tbody&gt;&amp;]:odd:bg-bg-500/10"><th class="text-text-000 [&amp;:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] px-2 [&amp;:not(:first-child)]:border-l-[0.5px]">Node</th><th class="text-text-000 [&amp;:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] px-2 [&amp;:not(:first-child)]:border-l-[0.5px]">IP Address</th><th class="text-text-000 [&amp;:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] px-2 [&amp;:not(:first-child)]:border-l-[0.5px]">RAM</th><th class="text-text-000 [&amp;:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] px-2 [&amp;:not(:first-child)]:border-l-[0.5px]">CPUs</th><th class="text-text-000 [&amp;:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] px-2 [&amp;:not(:first-child)]:border-l-[0.5px]">Role</th></tr></thead><tbody><tr class="[tbody&gt;&amp;]:odd:bg-bg-500/10"><td class="border-t-border-100/50 [&amp;:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&amp;:not(:first-child)]:border-l-[0.5px]">controlplane</td><td class="border-t-border-100/50 [&amp;:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&amp;:not(:first-child)]:border-l-[0.5px]">192.168.201.10</td><td class="border-t-border-100/50 [&amp;:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&amp;:not(:first-child)]:border-l-[0.5px]">4GB</td><td class="border-t-border-100/50 [&amp;:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&amp;:not(:first-child)]:border-l-[0.5px]">2</td><td class="border-t-border-100/50 [&amp;:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&amp;:not(:first-child)]:border-l-[0.5px]">Control Plane</td></tr><tr class="[tbody&gt;&amp;]:odd:bg-bg-500/10"><td class="border-t-border-100/50 [&amp;:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&amp;:not(:first-child)]:border-l-[0.5px]">node01</td><td class="border-t-border-100/50 [&amp;:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&amp;:not(:first-child)]:border-l-[0.5px]">192.168.201.11</td><td class="border-t-border-100/50 [&amp;:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&amp;:not(:first-child)]:border-l-[0.5px]">2GB</td><td class="border-t-border-100/50 [&amp;:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&amp;:not(:first-child)]:border-l-[0.5px]">1</td><td class="border-t-border-100/50 [&amp;:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&amp;:not(:first-child)]:border-l-[0.5px]">Worker Node</td></tr><tr class="[tbody&gt;&amp;]:odd:bg-bg-500/10"><td class="border-t-border-100/50 [&amp;:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&amp;:not(:first-child)]:border-l-[0.5px]">node02</td><td class="border-t-border-100/50 [&amp;:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&amp;:not(:first-child)]:border-l-[0.5px]">192.168.201.12</td><td class="border-t-border-100/50 [&amp;:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&amp;:not(:first-child)]:border-l-[0.5px]">2GB</td><td class="border-t-border-100/50 [&amp;:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&amp;:not(:first-child)]:border-l-[0.5px]">1</td><td class="border-t-border-100/50 [&amp;:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&amp;:not(:first-child)]:border-l-[0.5px]">Worker Node</td></tr></tbody></table>

# Project Structure
```bash
.
├── Vagrantfile              # VM definitions and provisioning
├── settings.yaml            # VM configuration (IPs, resources)
├── common.sh                # Setup script for all nodes
├── kubeadm.config           # Kubernetes cluster configuration
├── nginx-deployment.yaml    # Sample nginx deployment
└── README.md                # This file
```


# Technology Stack
- Kubernetes: v1.33.2
- CRI-O Runtime: v1.33
- Base OS: Ubuntu 24.04 (Bento)
- CNI Plugin: Calico v3.30.0

# Step-by-Step Setup
**Step: 1 Clone and Initialize VMs**

Clone this repository and start the VMs:
```bash
git clone https://github.com/Comtechiess/kubeadm-cluster.git
cd kubeadm-cluster
vagrant up
```
**Step 2: Install Kubernetes Components on All Nodes**

The `common.sh` script installs Kubernetes and CRI-O on all nodes. Run this on each node (controlplane, node01, node02).

SSH into each node:
```bash 
vagrant ssh controlplane
```
Switch to root and run the setup script:
```bash
sudo su
chmod +x /vagrant/common.sh
/vagrant/common.sh
```
**Step 3: Initialize the Control Plane**

On the controlplane node only, initialize Kubernetes:
```bash
sudo kubeadm init --config=/vagrant/kubeadm.config
```
Wait approximately 5 minutes for initialization to complete.

**Step 4: Configure kubectl Access**

After initialization completes, run these commands on the controlplane:
```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
**Step 5: Join Worker Nodes**
The `kubeadm init` output will provide a join command. It looks like:
```bash
kubeadm join 192.168.201.10:6443 --token <token> \
    --discovery-token-ca-cert-hash sha256:<hash>
```
Copy this command and run it on both node01 and node02 (as root):
```bash
vagrant ssh node01
sudo su
# Paste the join command
vagrant ssh node02
sudo su
# Paste the join command 
```
**Step 6: Verify Node Status**

On the controlplane, check node status:
```bash
kubectl get nodes
```

You'll see nodes in `NotReady` state:
```bash
NAME           STATUS     ROLES           AGE   VERSION
controlplane   NotReady   control-plane   55m   v1.33.2
node01         NotReady   <none>          8m    v1.33.2
node02         NotReady   <none>          8m    v1.33.2
```
This is expected because the CNI plugin hasn't been installed yet.

**Step 7: Install Calico CNI Plugin**

On the controlplane, install Calico CNI:
```bash
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.30.0/manifests/calico.yaml
```
Wait 2-3 minutes and check nodes again:
```bash
kubectl get nodes
```
All nodes should now be `Ready`:
```bash
NAME           STATUS   ROLES           AGE   VERSION
controlplane   Ready    control-plane   60m   v1.33.2
node01         Ready    <none>          13m   v1.33.2
node02         Ready    <none>          13m   v1.33.2
```
Verify all pods are running:
```bash
kubectl get pods -A
```
**Step 8: Deploy Sample Application for testing**

Test your cluster with the included nginx deployment:
```bash
kubectl apply -f nginx-deployment.yaml
```
Verify the deployment:
```bash
kubectl get deployments
kubectl get pods
kubectl get services
```
Expected output:
```bash
NAME                              READY   STATUS    RESTARTS   AGE
nginx-deployment-96b9d695-9sztb   1/1     Running   0          40s
nginx-deployment-96b9d695-wvwrq   1/1     Running   0          40s
```
open in your browser:
- http://192.168.201.10:32000



# Cleanup

To destroy the Vagrant VMs, run:
```bash
vagrant destroy 
```

# References

- [Kubernetes Documentation](https://kubernetes.io/docs/home/)
- [Vagrant Documentation](https://developer.hashicorp.com/vagrant/docs)
- [kubeadm Reference](https://kubernetes.io/docs/reference/setup-tools/kubeadm/)
- [CRI-O Documentation](https://cri-o.io/)
