# Kubernetes Troubleshooting Guide

This guide provides essential commands and techniques for troubleshooting Kubernetes clusters, with a focus on control plane components.

## 1. Network Analysis with Netstat

Netstat is crucial for verifying connectivity between Kubernetes components:

```bash
# Check all listening TCP ports
sudo netstat -tuln

# Check for specific Kubernetes ports
sudo netstat -tuln | grep 6443    # API server
sudo netstat -tuln | grep 2379    # etcd client
sudo netstat -tuln | grep 2380    # etcd peer
sudo netstat -tuln | grep 10250   # Kubelet API
sudo netstat -tuln | grep 10257   # Controller manager
sudo netstat -tuln | grep 10259   # Scheduler

# View established connections
sudo netstat -antp | grep etcd    # View etcd connections
sudo netstat -antp | grep kube    # View kube-related connections
```

Testing connectivity with netcat:
```bash
# Test API server connectivity
nc -zv MASTER_IP 6443

# Test etcd connectivity
nc -zv 127.0.0.1 2379

# Test direct API server
curl -k https://MASTER_IP:6443/version
```

## 2. Service Management with Systemctl and Crictl

### Systemctl Commands

```bash
# Check status of kubelet
sudo systemctl status kubelet

# Verify if services are enabled to start on boot
sudo systemctl is-enabled kubelet
sudo systemctl is-enabled containerd

# Start, stop, restart services
sudo systemctl restart kubelet
sudo systemctl restart containerd

# View recent service logs
sudo journalctl -u kubelet --since "10 minutes ago"
sudo journalctl -u containerd --since "10 minutes ago"
```

### Crictl Commands

```bash
# List all pods
sudo crictl pods

# List pods with specific filters
sudo crictl pods | grep kube-system
sudo crictl pods | grep api
sudo crictl pods | grep etcd

# List containers
sudo crictl ps -a

# List containers in a specific pod
sudo crictl ps -a --pod=POD_ID

# Get container details
sudo crictl inspect CONTAINER_ID

# Get pod details
sudo crictl inspectp POD_ID

# View container logs
sudo crictl logs CONTAINER_ID

# View logs for a container in a specific pod
sudo crictl logs $(sudo crictl ps -a --pod=$(sudo crictl pods | grep etcd | awk '{print $1}') | grep etcd | awk '{print $1}')
```

## 3. Finding and Viewing Logs

### Kubelet Logs

```bash
# View kubelet logs
sudo journalctl -u kubelet -n 100
sudo journalctl -u kubelet --since "10 minutes ago"

# View kubelet logs with specific filters
sudo journalctl -u kubelet | grep -i error
sudo journalctl -u kubelet | grep -i apiserver
```

### Container Runtime Logs

```bash
# View containerd logs
sudo journalctl -u containerd -n 100

# View logs for specific containers
sudo crictl logs CONTAINER_ID

# Tail logs of a container
sudo crictl logs -f CONTAINER_ID
```

### Control Plane Component Logs

```bash
# Get API server container ID
API_CONTAINER=$(sudo crictl ps -a | grep kube-apiserver | grep -v pause | awk '{print $1}')

# View API server logs
sudo crictl logs $API_CONTAINER

# Get etcd container ID
ETCD_CONTAINER=$(sudo crictl ps -a | grep etcd | grep -v pause | awk '{print $1}')

# View etcd logs
sudo crictl logs $ETCD_CONTAINER

# Get scheduler container ID
SCHEDULER_CONTAINER=$(sudo crictl ps -a | grep kube-scheduler | grep -v pause | awk '{print $1}')

# View scheduler logs
sudo crictl logs $SCHEDULER_CONTAINER

# Get controller manager container ID
CM_CONTAINER=$(sudo crictl ps -a | grep kube-controller-manager | grep -v pause | awk '{print $1}')

# View controller manager logs
sudo crictl logs $CM_CONTAINER
```

## 4. Configuration Files and Their Locations

### Kubelet Configuration

```bash
# Kubelet configuration
/etc/systemd/system/kubelet.service.d/10-kubeadm.conf
/var/lib/kubelet/config.yaml
```

### Static Pod Manifests

```bash
# Directory containing static pod manifests
/etc/kubernetes/manifests/

# Individual manifests
/etc/kubernetes/manifests/etcd.yaml
/etc/kubernetes/manifests/kube-apiserver.yaml
/etc/kubernetes/manifests/kube-controller-manager.yaml
/etc/kubernetes/manifests/kube-scheduler.yaml
```

### Kubeadm Configuration

```bash
# Kubeadm config
/etc/kubernetes/kubeadm-config.yaml

# Kubeconfig for admin
/etc/kubernetes/admin.conf
~/.kube/config
```

### Container Runtime Configuration

```bash
# Containerd configuration
/etc/containerd/config.toml
```

### Certificate Files

```bash
# Kubernetes certificates
/etc/kubernetes/pki/
/etc/kubernetes/pki/etcd/   # etcd-specific certificates
```

## 5. Common Troubleshooting Scenarios

### API Server Not Starting

```bash
# Check API server logs
sudo crictl logs $(sudo crictl ps -a | grep kube-apiserver | grep -v pause | awk '{print $1}')

# Verify etcd is running
sudo crictl ps | grep etcd

# Check certificate validity
sudo openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text -noout | grep -A2 Validity

# Restart API server by moving its manifest temporarily
sudo mv /etc/kubernetes/manifests/kube-apiserver.yaml /tmp/
sudo systemctl restart kubelet
sleep 30
sudo mv /tmp/kube-apiserver.yaml /etc/kubernetes/manifests/
sudo systemctl restart kubelet
```

### Etcd Issues

```bash
# Check etcd logs
sudo crictl logs $(sudo crictl ps -a | grep etcd | grep -v pause | awk '{print $1}')

# Verify etcd is listening
sudo netstat -tuln | grep 2379

# Check etcd certificate validity
sudo openssl x509 -in /etc/kubernetes/pki/etcd/server.crt -text -noout | grep -A2 Validity
```

### Sequenced Restart for Timing Issues

```bash
# Move all control plane manifests to temporary location
sudo mkdir -p /tmp/k8s-manifests
sudo mv /etc/kubernetes/manifests/*.yaml /tmp/k8s-manifests/
sudo systemctl restart kubelet

# Wait for pods to terminate
sleep 60

# Move etcd back first and wait for it to start
sudo mv /tmp/k8s-manifests/etcd.yaml /etc/kubernetes/manifests/
sudo systemctl restart kubelet

# Wait for etcd to initialize
sleep 90

# Move other control plane components back
sudo mv /tmp/k8s-manifests/*.yaml /etc/kubernetes/manifests/
sudo systemctl restart kubelet
```

### Kubelet Not Starting

```bash
# Check kubelet status
sudo systemctl status kubelet

# View detailed kubelet logs
sudo journalctl -u kubelet -n 500

# Verify kubelet is enabled to start on boot
sudo systemctl enable kubelet

# Check kubelet configuration
sudo cat /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
```

## 6. Advanced Troubleshooting

### Modifying API Server Options

```bash
# Add additional timeout parameters to API server
sudo cp /etc/kubernetes/manifests/kube-apiserver.yaml /tmp/kube-apiserver.yaml.bak
sudo sed -i 's/- kube-apiserver/- kube-apiserver\n    - --etcd-dial-timeout=30s\n    - --etcd-request-timeout=30s/' /etc/kubernetes/manifests/kube-apiserver.yaml
sudo systemctl restart kubelet
```

### Checking Firewall Settings

```bash
# View iptables rules
sudo iptables -L -n

# Check for blocked connections
sudo iptables -nvL | grep DROP

# Check if required ports are being blocked
sudo iptables -L -n | grep 6443
sudo iptables -L -n | grep 2379
```

### Checking Certificate Permissions

```bash
# Verify certificate file permissions
sudo ls -la /etc/kubernetes/pki/
sudo ls -la /etc/kubernetes/pki/etcd/

# Check specific certificates
sudo ls -la /etc/kubernetes/pki/apiserver* /etc/kubernetes/pki/etcd/ca.crt
```

This guide should help you diagnose and fix common issues in Kubernetes clusters, especially those related to the initialization and communication between control plane components.
