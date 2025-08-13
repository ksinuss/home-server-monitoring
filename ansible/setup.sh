#!/bin/bash

read -p "Enter SSH username: " SSH_USER
read -p "Enter server IP address: " SERVER_IP
read -p "Enter SSH private key path [~/.ssh/ansible_key]: " SSH_KEY
SSH_KEY=${SSH_KEY:-~/.ssh/ansible_key}

# Create inventory
cat > inventories/production/hosts.ini <<EOF
[home_servers]
home-server ansible_host=$SERVER_IP

[home_servers:vars]
EOF

# Create group variables
cat > inventories/production/group_vars/home_servers.yml <<EOF
---
ansible_user: $SSH_USER
server_ip: $SERVER_IP
ssh_key_path: $SSH_KEY
EOF

# Generate SSH key if needed
if [ ! -f "${SSH_KEY/#\~/$HOME}" ]; then
    ssh-keygen -t ed25519 -f "${SSH_KEY/#\~/$HOME}" -N ""
    echo "SSH key generated at $SSH_KEY"
fi

echo "Configuration complete. Run: ansible-playbook playbooks/site.yml"
