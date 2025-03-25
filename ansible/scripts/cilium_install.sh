#!/bin/bash
# Script to install Cilium on Kubernetes cluster

set -e  # Exit on any error

echo "Starting Cilium installation..."

# Check if kubectl is accessible and cluster is running
if ! kubectl get nodes &>/dev/null; then
    echo "Error: Cannot connect to Kubernetes cluster. Make sure your cluster is running and kubectl is properly configured."
    exit 1
fi

echo "Detected Kubernetes version:"
kubectl version | grep -i "server version"

echo "Checking Linux kernel version (must be >= 5.4):"
uname -r

echo "Installing Cilium CLI..."
# Download and install Cilium CLI using the official method
CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)
CLI_ARCH=amd64
if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi
echo "Downloading Cilium CLI version ${CILIUM_CLI_VERSION} for ${CLI_ARCH}"

curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
rm cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}

echo "Cilium CLI installed at $(which cilium)"
cilium version

echo "Installing Cilium on the cluster..."
# Using a stable Cilium version that's compatible with Kubernetes v1.31.5
cilium install

echo "Waiting for Cilium to be ready..."
cilium status --wait

echo "Verifying Cilium installation..."
cilium status

echo "Cilium installation completed successfully!"
echo ""
echo "Next steps:"
echo "1. Verify pods are running: kubectl get pods -n kube-system"
echo "2. Verify nodes are in Ready state: kubectl get nodes"
echo "3. Test pod networking by deploying a sample application"
echo "4. Convert this script into Ansible tasks once verified"