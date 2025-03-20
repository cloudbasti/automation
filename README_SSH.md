# Managing SSH Keys with OpenSSH for Git and Remote Servers

This guide covers how to create, load, and unload SSH keys for Git repositories and remote servers using the OpenSSH client.

## Prerequisites

- OpenSSH client installed on Windows

## Creating SSH Keys

### On Windows

To create a new SSH key on Windows:

```bash
ssh-keygen -t rsa -b 4096 -f C:\Users\YourUsername\.ssh\your_key_name -C "your_email@example.com"
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
ssh -i "C:\Users\username\path\to\keys\dev_server_key" user@192.168.1.10
```

Connect to a cloud instance (e.g., AWS EC2):

```bash
ssh -i "C:\Users\username\path\to\keys\cloud_instance_key" ec2-user@ec2-12-345-67-890.compute-1.amazonaws.com
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

