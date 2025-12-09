#!/bin/bash

# Log everything
exec > /var/log/userdata_bastion.log 2>&1

echo "==== Starting Bastion Setup ===="

# Update system
yum update -y

# Install useful tools
yum install -y telnet
yum install -y bind-utils
yum install -y git
yum install -y awscli
yum install -y curl
yum install -y jq

# Disable password authentication (security)
sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl restart sshd

# Enable logging for SSH
yum install -y rsyslog
systemctl enable rsyslog
systemctl start rsyslog

echo "==== Bastion Host Ready ===="
