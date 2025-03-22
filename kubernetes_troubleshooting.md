# Kubernetes Troubleshooting Guide

This guide provides commands and techniques for troubleshooting Kubernetes clusters, services, and networking issues.

## Table of Contents
- [Cluster Status](#cluster-status)
- [Pod and Node Troubleshooting](#pod-and-node-troubleshooting)
- [Service and Network Policies](#service-and-network-policies)
- [Logs and Events](#logs-and-events)

## Cluster Status

Check cluster info:
```bash
# Display addresses of the control plane and cluster services
kubectl cluster-info
# Shows master and service endpoints

# List all nodes in the cluster with status
kubectl get nodes
# Shows all nodes with their status, roles, age, and Kubernetes version
```

Verify control plane components:
```bash
# Check all system pods including control plane components
kubectl get pods -n kube-system
# Shows status of critical components like kube-apiserver, 
# kube-scheduler, kube-controller-manager and more
```

Check API server availability:
```bash
# From worker node, test API server connectivity
curl -k https://MASTER_IP:6443/version
# Queries the API server directly to verify it's responding
# The -k flag allows insecure connections

# Use netcat to check if port is open
nc -zv MASTER_IP 6443
# Quick check to verify the API server port is reachable
```

Detailed cluster component status:
```bash
# Advanced cluster component health check
kubectl get componentstatuses
# Shows the health status of controller-manager, scheduler, and etcd
```

## Pod and Node Troubleshooting

Check pod status:
```bash
# List all pods across all namespaces
kubectl get pods --all-namespaces
# Shows running/failing pods across entire cluster

# Get detailed information about a specific pod
kubectl describe pod POD_NAME -n NAMESPACE
# Shows detailed pod info including events, which help identify issues
```

Check node status:
```bash
# Get detailed information about a node
kubectl describe node NODE_NAME
# Shows capacity, allocatable resources, conditions, and events
# Helps identify node-level issues
```

Debug with a temporary pod:
```bash
# Start a debugging container for network tests
kubectl run debug --image=busybox --rm -it -- sh
# Creates and connects to a temporary pod with basic tools
# Useful for testing network connectivity from inside the cluster
```

Resource usage:
```bash
# Get resource usage for nodes
kubectl top node
# Shows CPU and memory usage for each node

# Get resource usage for pods
kubectl top pod --all-namespaces
# Shows CPU and memory usage for each pod
```

## Service and Network Policies

Check services:
```bash
# List all services across all namespaces
kubectl get svc --all-namespaces
# Shows service names, types, cluster IPs, external IPs, ports, and age

# Get detailed service information
kubectl describe svc SERVICE_NAME -n NAMESPACE
# Shows detailed service configuration including endpoints and selector
```

Check network policies:
```bash
# List all network policies
kubectl get networkpolicies --all-namespaces
# Shows configured network security policies that control traffic flow
```

Debug service endpoints:
```bash
# Check if service is correctly selecting pods
kubectl get endpoints SERVICE_NAME -n NAMESPACE
# Shows the pod IPs that a service is routing traffic to
# Empty endpoints may indicate selector issues
```

Service connectivity testing:
```bash
# Test DNS resolution inside the cluster
kubectl run -it --rm debug --image=busybox -- nslookup SERVICE_NAME.NAMESPACE.svc.cluster.local
# Verifies if DNS is resolving service names correctly
```

## Logs and Events

View pod logs:
```bash
# Get logs from a pod
kubectl logs POD_NAME -n NAMESPACE
# Shows container logs for troubleshooting application issues

# Follow logs in real-time
kubectl logs -f POD_NAME -n NAMESPACE
# Streams logs as they're generated, useful for real-time debugging

# Show previous container logs
kubectl logs --previous POD_NAME -n NAMESPACE
# Retrieves logs from previous container if it crashed/restarted
```

View cluster events:
```bash
# Get all events, sorted by timestamp
kubectl get events --sort-by='.lastTimestamp'
# Shows cluster-wide events that help identify recent issues

# Events in specific namespace
kubectl get events -n NAMESPACE
# Narrows down events to a specific namespace
```

Get all resource info in a namespace:
```bash
# Comprehensive resource detail for a namespace
kubectl describe all -n NAMESPACE
# Shows details for all resources (pods, services, deployments, etc.)
# in the specified namespace
```

Debug with kubectl exec:
```bash
# Run commands in a running container
kubectl exec -it POD_NAME -n NAMESPACE -- bash
# Opens an interactive shell in a pod for debugging
# Use /bin/sh instead of bash for minimal containers
```
