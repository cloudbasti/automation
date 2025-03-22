# Linux SSH Security Configuration

## Essential SSH Security Measures

### Disable Password Authentication
```bash
sudo vi /etc/ssh/sshd_config
# Set "PasswordAuthentication no"
sudo systemctl restart ssh
```
Disables password-based logins, forcing the use of SSH keys which are more secure.

### Change Default SSH Port
```bash
sudo vi /etc/ssh/sshd_config
# Change "Port 22" to another value (e.g., "Port 2222")
sudo systemctl restart ssh
```
Reduces automated scan attacks targeting the default port.

### Limit User Access
```bash
sudo vi /etc/ssh/sshd_config
# Add "AllowUsers username1 username2"
# Or "DenyUsers username3 username4"
sudo systemctl restart ssh
```
Restricts SSH access to specific users only.

### Disable Root Login
```bash
sudo vi /etc/ssh/sshd_config
# Set "PermitRootLogin no"
sudo systemctl restart ssh
```
Prevents direct root login, enhancing security.

### Restrict SSH with Firewall (UFW)
```bash
sudo ufw allow from 192.168.1.0/24 to any port 2222
sudo ufw enable
```
This firewall command:
- Only allows SSH connections from the 192.168.1.0/24 subnet (your trusted network)
- Specifically targets port 2222 (assumes you changed from default port 22)
- The "sudo ufw enable" activates the firewall with these rules
- This blocks SSH attempts from all other IP addresses, significantly reducing attack surface
