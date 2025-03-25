#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "=== Kubernetes Pre-flight Verification ==="

if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Please run as root${NC}"
  exit 1
fi

echo -n "Checking swap status: "
SWAP=$(free -h | grep -i swap | awk '{print $2}')
if [[ "$SWAP" == "0B" || "$SWAP" == "0" ]]; then
  echo -e "${GREEN}Disabled${NC}"
else
  echo -e "${RED}Enabled ($SWAP) - Kubernetes requires swap to be disabled${NC}"
fi

echo -n "Checking overlay module: "
if lsmod | grep -q overlay; then
  echo -e "${GREEN}Loaded${NC}"
else
  echo -e "${RED}Not loaded${NC}"
fi

echo -n "Checking br_netfilter module: "
if lsmod | grep -q br_netfilter; then
  echo -e "${GREEN}Loaded${NC}"
else
  echo -e "${RED}Not loaded${NC}"
fi

echo "Checking kernel parameters:"
params=(
  "net.bridge.bridge-nf-call-iptables"
  "net.bridge.bridge-nf-call-ip6tables"
  "net.ipv4.ip_forward"
)

for param in "${params[@]}"; do
  value=$(sysctl -n $param 2>/dev/null)
  echo -n "  $param: "
  if [[ "$value" == "1" ]]; then
    echo -e "${GREEN}Set correctly${NC}"
  else
    echo -e "${RED}Not set correctly (value=$value, expected=1)${NC}"
  fi
done

echo -n "Checking if containerd is running: "
if systemctl is-active --quiet containerd; then
  echo -e "${GREEN}Running${NC}"
else
  echo -e "${RED}Not running${NC}"
fi

echo -n "Checking containerd SystemdCgroup setting: "
if grep -q "SystemdCgroup = true" /etc/containerd/config.toml; then
  echo -e "${GREEN}Configured correctly${NC}"
else
  echo -e "${RED}Not configured correctly${NC}"
fi

echo "Checking Kubernetes components:"

echo -n "  kubeadm: "
if command -v kubeadm >/dev/null; then
  VERSION=$(kubeadm version -o short)
  if [[ "$VERSION" == *"v1.31.5"* ]]; then
    echo -e "${GREEN}Installed (version $VERSION)${NC}"
  else
    echo -e "${RED}Wrong version (found $VERSION, expected v1.31.5)${NC}"
  fi
else
  echo -e "${RED}Not installed${NC}"
fi

echo -n "  kubelet: "
if command -v kubelet >/dev/null; then
  VERSION=$(kubelet --version | awk '{print $2}')
  if [[ "$VERSION" == *"v1.31.5"* ]]; then
    echo -e "${GREEN}Installed (version $VERSION)${NC}"
  else
    echo -e "${RED}Wrong version (found $VERSION, expected v1.31.5)${NC}"
  fi
else
  echo -e "${RED}Not installed${NC}"
fi

echo -n "  kubectl: "
if command -v kubectl >/dev/null; then
  VERSION=$(kubectl version --client -o yaml | grep gitVersion | head -n 1 | awk '{print $2}')
  if [[ "$VERSION" == *"v1.31.5"* ]]; then
    echo -e "${GREEN}Installed (version $VERSION)${NC}"
  else
    echo -e "${RED}Wrong version (found $VERSION, expected v1.31.5)${NC}"
  fi
else
  echo -e "${RED}Not installed${NC}"
fi

echo -n "Checking if Kubernetes packages are held: "
HELD_PKGS=$(apt-mark showhold | grep -c 'kube')
if [[ "$HELD_PKGS" -eq 3 ]]; then
  echo -e "${GREEN}All packages are held${NC}"
else
  echo -e "${RED}Not all packages are held (found $HELD_PKGS, expected 3)${NC}"
  apt-mark showhold | grep kube
fi

echo "=== Verification Complete ==="