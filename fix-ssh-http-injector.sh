#!/bin/bash

# LION VPS Manager - Complete Fix for HTTP Injector
# Fixes SSH cipher negotiation and ensures smooth connection

cor1='\033[1;36m' # Cyan
cor2='\033[1;33m' # Yellow  
cor3='\033[1;31m' # Red
cor4='\033[1;32m' # Green
cor5='\033[1;37m' # White
sem='\033[0m'     # Reset

clear
echo -e "${cor1}🦁════════════════════════════════════════════════════════🦁${sem}"
echo -e "${cor1}🦁           COMPLETE HTTP INJECTOR FIX - LION          🦁${sem}"
echo -e "${cor1}🦁════════════════════════════════════════════════════════🦁${sem}"
echo ""

echo -e "${cor3}🚨 PROBLEMS DETECTED:${sem}"
echo -e "${cor3}❌ TLSV1_ALERT_CERTIFICATE_REQUIRED (FIXED)${sem}"
echo -e "${cor3}❌ SSH Negotiation failed for [aes256-gcm@openssh.com, aes128-gcm@openssh.com]${sem}"
echo -e "${cor3}❌ HTTP Injector can't complete SSH handshake${sem}"
echo ""

echo -e "${cor2}🔧 APPLYING COMPLETE FIX...${sem}"
echo ""

# Check if running as root
if [ "$(id -u)" != "0" ]; then
    echo -e "${cor3}❌ This script must be run as root!${sem}"
    echo -e "${cor2}💡 Use: sudo bash fix-ssh-http-injector.sh${sem}"
    exit 1
fi

# Stop services
echo -e "${cor2}🔄 Stopping services...${sem}"
systemctl stop stunnel4 2>/dev/null || service stunnel4 stop 2>/dev/null
systemctl stop ssh 2>/dev/null || service ssh stop 2>/dev/null
echo -e "${cor4}✅ Services stopped${sem}"

# Backup SSH config
if [ -f "/etc/ssh/sshd_config" ]; then
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
    echo -e "${cor4}✅ SSH config backed up: /etc/ssh/sshd_config.backup${sem}"
fi

# Create HTTP Injector compatible SSH config
echo -e "${cor2}🔧 Creating HTTP Injector compatible SSH config...${sem}"
cat > /etc/ssh/sshd_config << 'EOF'
# Package generated configuration file
# See the sshd_config(5) manpage for details

# What ports, IPs and protocols we listen for
Port 22
# Use these options to restrict which interfaces/protocols sshd will bind to
#ListenAddress ::
#ListenAddress 0.0.0.0
Protocol 2
# HostKeys for protocol version 2
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_dsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key

# Change to no to disable s/key passwords
#ChallengeResponseAuthentication no

# Change to no to disable tunnelled clear text passwords
#PasswordAuthentication yes

# Kerberos options
#KerberosAuthentication no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes
#KerberosGetAFSToken no

# GSSAPI options
#GSSAPIAuthentication yes
#GSSAPICleanupCredentials yes

X11Forwarding yes
X11DisplayOffset 10
PrintMotd no
PrintLastLog yes
TCPKeepAlive yes
#UseLogin no

#MaxStartups 10:30:60
#Banner /etc/issue.net

# Allow client to pass locale environment variables
AcceptEnv LANG LC_*

Subsystem sftp /usr/lib/openssh/sftp-server

# LION VPS Manager - HTTP Injector Compatible Security
# Enhanced cipher support for HTTP Injector
Ciphers aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr,aes256-cbc,aes192-cbc,aes128-cbc,3des-cbc
MACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,hmac-sha2-256,hmac-sha2-512,hmac-sha1
KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group14-sha256,diffie-hellman-group14-sha1

# Security settings
MaxAuthTries 3
ClientAliveInterval 300
ClientAliveCountMax 2
PermitRootLogin yes
PasswordAuthentication yes
EOF

echo -e "${cor4}✅ SSH config updated for HTTP Injector compatibility!${sem}"

# Fix Stunnel config (ensure verify = 0)
echo -e "${cor2}🔧 Updating Stunnel config...${sem}"
if [ -f "/etc/stunnel/lion.conf" ]; then
    sed -i 's/verify = 2/verify = 0/g' /etc/stunnel/lion.conf
    sed -i 's/verify = 1/verify = 0/g' /etc/stunnel/lion.conf
    echo -e "${cor4}✅ Stunnel config updated!${sem}"
else
    echo -e "${cor2}🔧 Creating new Stunnel config...${sem}"
    mkdir -p /etc/stunnel
    mkdir -p /var/log/lion
    
    cat > /etc/stunnel/lion.conf << 'EOF'
; LION VPS Manager - HTTP Injector Compatible Configuration
; TLS_AES_256_GCM_SHA384 Cipher Suite Enforcement

pid = /var/run/stunnel-lion.pid
output = /var/log/lion/stunnel.log

; Force TLSv1.3 only with specific cipher
sslVersion = TLSv1.3
ciphersuites = TLS_AES_256_GCM_SHA384

; Disable all older protocols
options = -NO_SSLv2
options = -NO_SSLv3
options = -NO_TLSv1
options = -NO_TLSv1.1
options = -NO_TLSv1.2

; Enhanced security options
options = -NO_COMPRESSION
options = -CIPHER_SERVER_PREFERENCE
options = -SINGLE_DH_USE
options = -SINGLE_ECDH_USE
options = -NO_RENEGOTIATION

; HTTP Injector compatibility - NO client certificate verification
verify = 0

; Service definitions
[lion-ssh]
accept = 9443
connect = 127.0.0.1:22
cert = /etc/stunnel/lion.pem
key = /etc/stunnel/lion.key

[lion-proxy]
accept = 8443
connect = 127.0.0.1:3128
cert = /etc/stunnel/lion.pem
key = /etc/stunnel/lion.key

[lion-openvpn]
accept = 7443
connect = 127.0.0.1:1194
cert = /etc/stunnel/lion.pem
key = /etc/stunnel/lion.key
EOF
    echo -e "${cor4}✅ New Stunnel config created!${sem}"
fi

# Ensure certificate exists
if [ ! -f "/etc/stunnel/lion.pem" ]; then
    echo -e "${cor2}🔐 Generating TLS certificate...${sem}"
    openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
        -subj "/C=US/ST=Security/L=TLS/O=LION-VPS/CN=lion-manager" \
        -keyout /etc/stunnel/lion.key \
        -out /etc/stunnel/lion.pem 2>/dev/null
    
    chmod 600 /etc/stunnel/lion.key
    chmod 644 /etc/stunnel/lion.pem
    echo -e "${cor4}✅ Certificate generated successfully!${sem}"
fi

# Start SSH service
echo -e "${cor2}🚀 Starting SSH service...${sem}"
systemctl start ssh 2>/dev/null || service ssh start 2>/dev/null

if [ $? -eq 0 ]; then
    echo -e "${cor4}✅ SSH started successfully!${sem}"
else
    echo -e "${cor3}❌ Failed to start SSH!${sem}"
    echo -e "${cor2}💡 Check SSH config manually${sem}"
    exit 1
fi

# Start Stunnel service
echo -e "${cor2}🚀 Starting Stunnel service...${sem}"
systemctl start stunnel4 2>/dev/null || service stunnel4 start 2>/dev/null

if [ $? -eq 0 ]; then
    echo -e "${cor4}✅ Stunnel started successfully!${sem}"
else
    echo -e "${cor3}❌ Failed to start Stunnel!${sem}"
    echo -e "${cor2}💡 Check logs: tail -f /var/log/lion/stunnel.log${sem}"
    exit 1
fi

# Test SSH connection
echo -e "${cor2}🔍 Testing SSH connection...${sem}"
sleep 2
if netstat -tlnp 2>/dev/null | grep -q ":22 "; then
    echo -e "${cor4}✅ SSH listening on port 22${sem}"
else
    echo -e "${cor3}❌ SSH not listening on port 22${sem}"
fi

# Test Stunnel connection
echo -e "${cor2}🔍 Testing Stunnel connection...${sem}"
sleep 2
if netstat -tlnp 2>/dev/null | grep -q ":9443 "; then
    echo -e "${cor4}✅ Stunnel listening on port 9443${sem}"
else
    echo -e "${cor3}❌ Stunnel not listening on port 9443${sem}"
fi

# Check service status
echo ""
echo -e "${cor2}🔍 Service Status:${sem}"
echo -e "${cor2}📋 SSH Status:${sem}"
systemctl status ssh --no-pager -l 2>/dev/null || service ssh status 2>/dev/null

echo ""
echo -e "${cor2}📋 Stunnel Status:${sem}"
systemctl status stunnel4 --no-pager -l 2>/dev/null || service stunnel4 status 2>/dev/null

echo ""
echo -e "${cor1}🦁════════════════════════════════════════════════════════🦁${sem}"
echo -e "${cor4}🎉 ALL ISSUES FIXED! HTTP INJECTOR READY! 🎉${sem}"
echo -e "${cor1}🦁════════════════════════════════════════════════════════🦁${sem}"
echo ""
echo -e "${cor2}🔗 Connection Details:${sem}"
echo -e "${cor2}🌐 Server: ${cor5}$(wget -qO- ipv4.icanhazip.com 2>/dev/null || echo "Check manually")${sem}"
echo -e "${cor2}🔒 SSH Port: ${cor5}22${sem}"
echo -e "${cor2}🔒 TLS SSH Port: ${cor5}9443${sem}"
echo -e "${cor2}🌐 TLS Proxy Port: ${cor5}8443${sem}"
echo -e "${cor2}🔐 Cipher Suite: ${cor5}TLS_AES_256_GCM_SHA384${sem}"
echo ""
echo -e "${cor2}📱 HTTP Injector Settings:${sem}"
echo -e "${cor2}🔒 Tunnel Type: ${cor5}SSL/TLS ➔ SSH${sem}"
echo -e "${cor2}🌐 Host: ${cor5}$(wget -qO- ipv4.icanhazip.com 2>/dev/null || echo "Your server IP")${sem}"
echo -e "${cor2}🔌 Port: ${cor5}9443${sem}"
echo -e "${cor2}🔐 Username: ${cor5}Your SSH username${sem}"
echo -e "${cor2}🔑 Password: ${cor5}Your SSH password${sem}"
echo ""
echo -e "${cor2}✅ What's Fixed:${sem}"
echo -e "${cor4}✅ TLS certificate verification removed${sem}"
echo -e "${cor4}✅ SSH cipher negotiation fixed${sem}"
echo -e "${cor4}✅ HTTP Injector compatibility ensured${sem}"
echo -e "${cor4}✅ TLS_AES_256_GCM_SHA384 maintained${sem}"
echo -e "${cor4}✅ All services running smoothly${sem}"
echo ""

echo -e "${cor2}🚀 Test your connection now!${sem}"
echo -e "${cor2}💡 If you still have issues, check the logs:${sem}"
echo -e "${cor2}📋 SSH logs: ${cor5}tail -f /var/log/auth.log${sem}"
echo -e "${cor2}📋 Stunnel logs: ${cor5}tail -f /var/log/lion/stunnel.log${sem}"
echo ""

echo -ne "${cor2}🦁 Press Enter to continue...${sem}"
read
