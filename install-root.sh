#!/bin/bash

# LION VPS MANAGER - Ubuntu 20.04 ROOT Installation Script
# TLS_AES_256_GCM_SHA384 Enhanced Security

clear
echo -e "\033[1;36m🦁 LION VPS MANAGER - ROOT INSTALLER 🦁\033[0m"
echo -e "\033[1;33m🔐 TLS_AES_256_GCM_SHA384 Security Protocol\033[0m"
echo ""

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo -e "\033[1;31m❌ This ROOT installer must be run as root!\033[0m"
   echo -e "\033[1;33m🦁 Please run: sudo su - then try again\033[0m"
   exit 1
fi

echo -e "\033[1;32m✅ ROOT user detected - proceeding with installation\033[0m"
echo ""

# System update
echo -e "\033[1;34m🔄 Updating system packages...\033[0m"
apt update -y > /dev/null 2>&1 && apt upgrade -y > /dev/null 2>&1

# Install packages
echo -e "\033[1;34m🔄 Installing essential packages...\033[0m"
apt install -y curl wget git nano unzip screen net-tools lsof bc dos2unix jq figlet openssl ssl-cert ca-certificates openssh-server ufw fail2ban stunnel4 python3 python3-pip > /dev/null 2>&1

# Enable stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4 2>/dev/null

# Configure firewall
ufw --force enable > /dev/null 2>&1
ufw allow 22/tcp > /dev/null 2>&1
ufw allow 9443/tcp > /dev/null 2>&1
ufw allow 8443/tcp > /dev/null 2>&1

# Download and install LION
echo -e "\033[1;34m🔄 Downloading LION Manager...\033[0m"
cd /tmp
wget -q https://raw.githubusercontent.com/mkkelati/lion/main/lion
chmod +x lion
./lion

echo ""
echo -e "\033[1;32m🎉 LION VPS Manager installation complete!\033[0m"
echo -e "\033[1;33m🚀 Run: lion\033[0m"
echo ""
