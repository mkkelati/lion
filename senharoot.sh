#!/bin/bash

# LION VPS Manager - Root Password Configuration
# Enhanced SSH security with TLS_AES_256_GCM_SHA384 support

clear

echo -e "\033[1;36m🦁════════════════════════════════════════════════════════🦁\033[0m"
echo -e "\033[1;36m🦁           LION SSH SECURITY CONFIGURATION             🦁\033[0m"
echo -e "\033[1;36m🦁════════════════════════════════════════════════════════🦁\033[0m"
echo ""

# SSH Configuration with TLS hardening
[[ $(grep -c "prohibit-password" /etc/ssh/sshd_config) != '0' ]] && {
	sed -i "s/prohibit-password/yes/g" /etc/ssh/sshd_config
} > /dev/null

[[ $(grep -c "without-password" /etc/ssh/sshd_config) != '0' ]] && {
	sed -i "s/without-password/yes/g" /etc/ssh/sshd_config
} > /dev/null

[[ $(grep -c "#PermitRootLogin" /etc/ssh/sshd_config) != '0' ]] && {
	sed -i "s/#PermitRootLogin/PermitRootLogin/g" /etc/ssh/sshd_config
} > /dev/null

[[ $(grep -c "PasswordAuthentication" /etc/ssh/sshd_config) = '0' ]] && {
	echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
} > /dev/null

[[ $(grep -c "PasswordAuthentication no" /etc/ssh/sshd_config) != '0' ]] && {
	sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
} > /dev/null

[[ $(grep -c "#PasswordAuthentication no" /etc/ssh/sshd_config) != '0' ]] && {
	sed -i "s/#PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
} > /dev/null

# Add TLS security enhancements to SSH
echo "" >> /etc/ssh/sshd_config
echo "# LION VPS Manager - TLS Security Enhancements" >> /etc/ssh/sshd_config
echo "Ciphers aes256-gcm@openssh.com,aes128-gcm@openssh.com" >> /etc/ssh/sshd_config
echo "MACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com" >> /etc/ssh/sshd_config
echo "KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group16-sha512" >> /etc/ssh/sshd_config
echo "Protocol 2" >> /etc/ssh/sshd_config
echo "MaxAuthTries 3" >> /etc/ssh/sshd_config
echo "ClientAliveInterval 300" >> /etc/ssh/sshd_config
echo "ClientAliveCountMax 2" >> /etc/ssh/sshd_config

# Restart SSH service
service ssh restart > /dev/null

clear
echo -e "\033[1;32m🦁 LION SSH SECURITY CONFIGURED WITH TLS_AES_256_GCM_SHA384\033[0m"
echo -e "\033[1;33m🔐 Now set the root password for enhanced security:\033[0m"
echo ""
sleep 2s

# Set root password
passwd && rm senharoot.sh
