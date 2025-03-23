# Linux Network Troubleshooting Guide

This guide provides commands and techniques for troubleshooting network connectivity and service availability in Linux environments.

## Table of Contents
- [Service Status Checking](#service-status-checking)
- [Port and Socket Checking](#port-and-socket-checking)
- [Network Connectivity](#network-connectivity)
- [Firewall Management](#firewall-management)

## Service Status Checking

Check status of a service:
```bash
sudo systemctl status SERVICE_NAME
```

Start, stop, or restart a service:
```bash
sudo systemctl start SERVICE_NAME
sudo systemctl stop SERVICE_NAME
sudo systemctl restart SERVICE_NAME
```

Enable/disable service at boot:
```bash
sudo systemctl enable SERVICE_NAME
sudo systemctl disable SERVICE_NAME
```

View service logs:
```bash
sudo journalctl -u SERVICE_NAME
# Follow logs in real-time
sudo journalctl -u SERVICE_NAME -f
```

## Port and Socket Checking

Check listening ports with ss (Socket Statistics):
```bash
# List all TCP ports
sudo ss -tunlp
# -t (TCP), -u (UDP), -n (numeric), -l (listening), -p (processes)
# Shows all listening TCP/UDP ports with process information

# Check specific port (e.g., Kubernetes API Server)
sudo ss -tunlp | grep 6443
# Filters output to show only the Kubernetes API server port
```

Alternative using netstat:
```bash
# List all TCP ports
sudo netstat -tunlp
# Similar to ss but older tool, still widely used
# -t (TCP), -u (UDP), -n (numeric), -l (listening), -p (processes)

# Check specific port
sudo netstat -tunlp | grep 6443
# Checks if the Kubernetes API server is listening on port 6443
```

Check if a port is reachable:
```bash
# Test TCP connection to a specific port
nc -zv hostname port
# nc (netcat) with -z (zero-I/O mode, just scan) and -v (verbose)
# checks if a port is open without sending data

# Example: Check if Kubernetes API server is reachable
nc -zv 192.168.1.100 6443
```

## Network Connectivity

Basic connectivity testing:
```bash
# Test basic connectivity with ICMP echo
ping hostname

# Trace the network path to a destination
traceroute hostname
# traceroute shows the complete path packets take to reach a destination,
# displaying each router/hop along the way and the time it takes to reach each hop
```

Combined network path and latency testing:
```bash
# More advanced path tracing with continuous updates
mtr hostname
# mtr combines ping and traceroute into one tool, providing real-time
# statistics about each hop in the network path
```

DNS resolution tools:
```bash
# Query DNS servers for IP address information
nslookup hostname
# Basic DNS lookup tool that queries nameservers to find IP addresses for domains

# Advanced DNS query tool with detailed output
dig hostname
# dig (Domain Information Groper) provides comprehensive DNS information
# including query details, answer section, authority, and more

# Simple hostname to IP lookup
host hostname
# Simplified DNS lookup tool that converts hostnames to IP addresses or vice versa
```

Check network interfaces:
```bash
# Modern Linux command to view network interfaces
ip addr show
# Displays detailed information about all network interfaces including
# IP addresses, MAC addresses, and interface states

# Traditional command (deprecated on newer systems)
ifconfig
# Shows network interface configuration but may not be installed by default
# on newer Linux distributions
```

Route table information:
```bash
# Display kernel routing table with modern command
ip route
# Shows where network traffic will be directed for different destination networks

# Traditional command to display numeric routing table
route -n
# Shows kernel routing table with numeric addresses (no hostname resolution)
# The -n flag makes it faster by skipping DNS lookups
```

## Firewall Management

Check firewall status (UFW):
```bash
# Display Uncomplicated Firewall status and rules
sudo ufw status
# Shows if the firewall is active and which rules are configured
```

Check firewall status (iptables):
```bash
# Display detailed iptables firewall rules
sudo iptables -L -n -v
# -L lists all rules, -n shows numeric addresses, -v provides verbose output
# Shows low-level packet filtering rules
```

Temporarily disable firewall:
```bash
# Disable the Uncomplicated Firewall
sudo ufw disable  # UFW
# Turn off firewalld service
sudo systemctl stop firewalld  # firewalld
```
