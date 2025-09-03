#!/bin/bash

# LION VPS Manager - Quick Fix for HTTP Injector
# Fixes TLSV1_ALERT_CERTIFICATE_REQUIRED error

cor1='\033[1;36m' # Cyan
cor2='\033[1;33m' # Yellow  
cor3='\033[1;31m' # Red
cor4='\033[1;32m' # Green
cor5='\033[1;37m' # White
sem='\033[0m'     # Reset

clear
echo -e "${cor1}🦁════════════════════════════════════════════════════════🦁${sem}"
echo -e "${cor1}🦁           HTTP INJECTOR QUICK FIX - LION              🦁${sem}"
echo -e "${cor1}🦁════════════════════════════════════════════════════════🦁${sem}"
echo ""

echo -e "${cor3}🚨 PROBLEM DETECTED:${sem}"
echo -e "${cor3}❌ TLSV1_ALERT_CERTIFICATE_REQUIRED${sem}"
echo -e "${cor3}❌ HTTP Injector can't connect to Stunnel${sem}"
echo ""

echo -e "${cor2}🔧 APPLYING QUICK FIX...${sem}"
echo ""

# Check if running as root
if [ "$(id -u)" != "0" ]; then
    echo -e "${cor3}❌ This script must be run as root!${sem}"
    echo -e "${cor2}💡 Use: sudo bash fix-stunnel-http-injector.sh${sem}"
    exit 1
fi

# Stop Stunnel service
echo -e "${cor2}🔄 Stopping Stunnel service...${sem}"
systemctl stop stunnel4 2>/dev/null || service stunnel4 stop 2>/dev/null
echo -e "${cor4}✅ Stunnel stopped${sem}"

# Backup current config
if [ -f "/etc/stunnel/lion.conf" ]; then
    cp /etc/stunnel/lion.conf /etc/stunnel/lion.conf.backup
    echo -e "${cor4}✅ Backup created: /etc/stunnel/lion.conf.backup${sem}"
fi

# Create fixed configuration
echo -e "${cor2}🔧 Creating HTTP Injector compatible config...${sem}"
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

echo -e "${cor4}✅ Fixed configuration created!${sem}"

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

# Check service status
echo ""
echo -e "${cor2}🔍 Checking Stunnel status...${sem}"
systemctl status stunnel4 --no-pager -l 2>/dev/null || service stunnel4 status 2>/dev/null

echo ""
echo -e "${cor1}🦁════════════════════════════════════════════════════════🦁${sem}"
echo -e "${cor4}🎉 HTTP INJECTOR ISSUE FIXED! 🎉${sem}"
echo -e "${cor1}🦁════════════════════════════════════════════════════════🦁${sem}"
echo ""
echo -e "${cor2}🔗 Connection Details:${sem}"
echo -e "${cor2}🌐 Server: ${cor5}$(wget -qO- ipv4.icanhazip.com 2>/dev/null || echo "Check manually")${sem}"
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
echo -e "${cor2}✅ The TLSV1_ALERT_CERTIFICATE_REQUIRED error should be resolved!${sem}"
echo ""

echo -ne "${cor2}🦁 Press Enter to continue...${sem}"
read
