# Managing SSH Keys with OpenSSH for Git and Remote Servers
This guide covers how to create, load, and unload SSH keys for Git repositories and remote servers using the OpenSSH client.

> **Important Note about Windows Paths**: When using OpenSSH commands on Windows, always use forward slashes (/) instead of backslashes (\\) in file paths. While Windows typically uses backslashes, OpenSSH was designed for Unix-like systems and expects forward slashes. Using backslashes can cause errors because they are treated as escape characters in shell environments.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Creating SSH Keys](#creating-ssh-keys)
  - [On Windows](#on-windows)
  - [On Linux](#on-linux)
- [Connecting to Remote Servers](#connecting-to-remote-servers)
- [File Transfers with SCP](#file-transfers-with-scp)
- [Checking SSH Agent Status](#checking-ssh-agent-status)
- [Managing SSH Keys](#managing-ssh-keys)
  - [Viewing Loaded Keys](#viewing-loaded-keys)
  - [Loading SSH Keys](#loading-ssh-keys)
  - [Unloading SSH Keys](#unloading-ssh-keys)
  - [Testing GitHub Connection](#testing-github-connection)

## Prerequisites
- OpenSSH client installed on Windows

## Creating SSH Keys
### On Windows
To create a new SSH key on Windows:
```bash
ssh-keygen -t rsa -b 4096 -f C:/Users/YourUsername/.ssh/your_key_name -C "your_email@example.com"
```
### On Linux
To create a new SSH key on a Linux machine or VM:
```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/your_git_key -C "your_email@example.com"
```
The command parameters:
- `-t rsa`: Specifies the type of key (RSA)
- `-b 4096`: Sets the key size to 4096 bits for stronger security
- `-f path/to/key`: Specifies where to save the key
- `-C "comment"`: Adds a comment (usually your email) to identify the key

## Connecting to Remote Servers
### Example Connections
Connect to a server (e.g., development environment):
```bash
ssh -i "C:/Users/username/path/to/keys/dev_server_key" user@192.168.1.10
```
Connect to a cloud instance (e.g., AWS EC2):
```bash
ssh -i "C:/Users/username/path/to/keys/cloud_instance_key" ec2-user@ec2-12-345-67-890.compute-1.amazonaws.com
```

## File Transfers with SCP

### Copying Files to Remote Servers
Copy a local file to a remote server:
```bash
scp -i /path/to/your/private-key.key /path/to/local/file username@server-address:/destination/directory/
```

Example with Windows path:
```bash
scp -i "C:/Users/Admin/Desktop/Automation/keys/aws_commander_key" "C:/Users/Admin/Desktop/local_file.txt" ubuntu@ec2-63-177-31-235.eu-central-1.compute.amazonaws.com:/home/ubuntu/
```

### Copying SSH Keys Between Machines
Transfer an SSH key to another server:
```bash
scp -i "C:/Users/Admin/Desktop/Automation/keys/aws_commander_key" "C:/Users/Admin/Desktop/Automation/keys/aws_kubernetes_worker" ubuntu@ec2-63-177-31-235.eu-central-1.compute.amazonaws.com:/home/ubuntu/.ssh/
```

### Copying Files from Remote Servers
Copy a remote file to your local machine:
```bash
scp -i /path/to/your/private-key.key username@server-address:/path/to/remote/file /local/destination/directory/
```

## Checking SSH Agent Status
First, check if the SSH agent is running:
```bash
# Start the SSH agent if not running
eval $(ssh-agent -s)
```
This command will output something like `Agent pid 12345` if successful.

## Managing SSH Keys
### Viewing Loaded Keys
To see which keys are currently loaded in the OpenSSH client:
```bash
ssh-add -l
```
If no keys are loaded, you'll see "The agent has no identities."

### Loading SSH Keys
Before loading keys, ensure they have the correct permissions:
```bash
chmod 600 ~/.ssh/your_private_key
```
Then add the key to the SSH agent:
```bash
ssh-add ~/.ssh/your_private_key
```

### Unloading SSH Keys
To remove a specific key:
```bash
ssh-add -d ~/.ssh/your_private_key
```
To remove all loaded keys:
```bash
ssh-add -D
```

### Testing GitHub Connection
```bash
ssh -T git@github.com
```
