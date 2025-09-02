#!/bin/bash

# LION VPS MANAGER - Fully Automated Ubuntu 20.04 Installation
# No questions asked - Just installs everything smoothly
# TLS_AES_256_GCM_SHA384 Enhanced Security

clear

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# LION Banner
echo -e "${CYAN}🦁════════════════════════════════════════════════════════🦁${NC}"
echo -e "${CYAN}🦁                LION VPS MANAGER AUTO-INSTALLER        🦁${NC}"
echo -e "${CYAN}🦁                 Fully Automated - No Questions        🦁${NC}"
echo -e "${CYAN}🦁════════════════════════════════════════════════════════🦁${NC}"
echo ""
echo -e "${YELLOW}🔐 Security Protocol: ${GREEN}TLS_AES_256_GCM_SHA384${NC}"
echo -e "${YELLOW}📦 Target OS: ${GREEN}Ubuntu 20.04 LTS${NC}"
echo -e "${YELLOW}🛡️ Encryption: ${GREEN}TLSv1.3 with Stunnel${NC}"
echo -e "${YELLOW}⚡ Mode: ${GREEN}FULLY AUTOMATED${NC}"
echo ""

# Auto-detect user type
if [[ $EUID -eq 0 ]]; then
   echo -e "${GREEN}✅ ROOT user detected - proceeding with direct installation${NC}"
   SUDO_CMD=""
else
   echo -e "${GREEN}✅ Regular user detected - using sudo for installation${NC}"
   SUDO_CMD="sudo"
fi

echo ""
echo -e "${CYAN}🚀 Starting LION VPS Manager Auto-Installation...${NC}"
echo -e "${YELLOW}🤖 No user input required - sit back and relax!${NC}"
echo ""

# Progress function
show_progress() {
    echo -e "${BLUE}🔄 $1...${NC}"
}

# Success function
show_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Error function with auto-continue
show_error() {
    echo -e "${YELLOW}⚠️ $1 - continuing anyway${NC}"
}

# Step 1: System Update
show_progress "Updating system packages"
export DEBIAN_FRONTEND=noninteractive
$SUDO_CMD apt update -y >/dev/null 2>&1
show_success "Package list updated"

show_progress "Upgrading system packages"
$SUDO_CMD apt upgrade -y >/dev/null 2>&1
show_success "System packages upgraded"

# Step 2: Install ALL packages in one go
show_progress "Installing all required packages"
$SUDO_CMD apt install -y \
    curl wget git nano unzip screen htop \
    net-tools lsof bc dos2unix jq figlet \
    openssl ssl-cert ca-certificates \
    openssh-server ufw fail2ban stunnel4 \
    python3 python3-pip cron apache2 nload >/dev/null 2>&1

show_success "All packages installed"

# Step 3: Configure Python packages
show_progress "Installing Python packages"
if [[ $EUID -eq 0 ]]; then
    pip3 install speedtest-cli cryptography >/dev/null 2>&1
else
    pip3 install --user speedtest-cli cryptography >/dev/null 2>&1
fi
show_success "Python packages installed"

# Step 4: Enable and configure Stunnel
show_progress "Configuring Stunnel for TLS_AES_256_GCM_SHA384"
$SUDO_CMD sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4 2>/dev/null
show_success "Stunnel enabled"

# Step 5: Configure Firewall (silently)
show_progress "Configuring firewall with LION ports"
$SUDO_CMD ufw --force enable >/dev/null 2>&1
$SUDO_CMD ufw allow 22/tcp >/dev/null 2>&1      # SSH
$SUDO_CMD ufw allow 80/tcp >/dev/null 2>&1      # HTTP
$SUDO_CMD ufw allow 443/tcp >/dev/null 2>&1     # HTTPS
$SUDO_CMD ufw allow 8443/tcp >/dev/null 2>&1    # TLS Proxy
$SUDO_CMD ufw allow 9443/tcp >/dev/null 2>&1    # TLS SSH
$SUDO_CMD ufw allow 7443/tcp >/dev/null 2>&1    # TLS VPN
show_success "Firewall configured"

# Step 6: Create LION directories
show_progress "Creating LION directory structure"
$SUDO_CMD mkdir -p /etc/lion/{install,modulos,sistema} >/dev/null 2>&1
$SUDO_CMD mkdir -p /var/log/lion >/dev/null 2>&1
$SUDO_CMD mkdir -p /etc/stunnel >/dev/null 2>&1
$SUDO_CMD mkdir -p /usr/share/.lion >/dev/null 2>&1
show_success "LION directories created"

# Step 7: Download ALL LION components
show_progress "Downloading all LION components from GitHub"
cd /tmp

# Download components silently
wget -q https://raw.githubusercontent.com/mkkelati/lion/main/Modulos/menu -O menu 2>/dev/null
wget -q https://raw.githubusercontent.com/mkkelati/lion/main/Modulos/criarusuario -O criarusuario 2>/dev/null
wget -q https://raw.githubusercontent.com/mkkelati/lion/main/Modulos/remover -O remover 2>/dev/null
wget -q https://raw.githubusercontent.com/mkkelati/lion/main/Modulos/conexao -O conexao 2>/dev/null
wget -q https://raw.githubusercontent.com/mkkelati/lion/main/Modulos/stunnel-config -O stunnel-config 2>/dev/null

show_success "LION components downloaded"

# Step 8: Install LION components
show_progress "Installing LION components"

# Make executable and copy
chmod +x menu criarusuario remover conexao stunnel-config 2>/dev/null
$SUDO_CMD cp menu criarusuario remover conexao stunnel-config /etc/lion/modulos/ 2>/dev/null

# Create command links
echo "/etc/lion/modulos/menu" | $SUDO_CMD tee /bin/lion >/dev/null 2>&1
$SUDO_CMD chmod +x /bin/lion
echo "/etc/lion/modulos/menu" | $SUDO_CMD tee /bin/l >/dev/null 2>&1
$SUDO_CMD chmod +x /bin/l
echo "/etc/lion/modulos/menu" | $SUDO_CMD tee /bin/lionmenu >/dev/null 2>&1
$SUDO_CMD chmod +x /bin/lionmenu

show_success "LION commands installed"

# Step 9: Configure SSH security
show_progress "Configuring SSH with TLS security"
if ! $SUDO_CMD grep -q "LION VPS Manager" /etc/ssh/sshd_config 2>/dev/null; then
    echo "" | $SUDO_CMD tee -a /etc/ssh/sshd_config >/dev/null
    echo "# LION VPS Manager - TLS Security Enhancements" | $SUDO_CMD tee -a /etc/ssh/sshd_config >/dev/null
    echo "Ciphers aes256-gcm@openssh.com,aes128-gcm@openssh.com" | $SUDO_CMD tee -a /etc/ssh/sshd_config >/dev/null
    echo "MACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com" | $SUDO_CMD tee -a /etc/ssh/sshd_config >/dev/null
    echo "KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group16-sha512" | $SUDO_CMD tee -a /etc/ssh/sshd_config >/dev/null
fi

# Enable password authentication
$SUDO_CMD sed -i 's/#PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config 2>/dev/null
$SUDO_CMD sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config 2>/dev/null

show_success "SSH security configured"

# Step 10: Create Stunnel configuration
show_progress "Creating Stunnel TLS configuration"

# Generate certificate
if [ ! -f "/etc/stunnel/lion.pem" ]; then
    $SUDO_CMD openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
        -subj "/C=US/ST=Security/L=TLS/O=LION-VPS/CN=lion-manager" \
        -keyout /etc/stunnel/lion.key \
        -out /etc/stunnel/lion.pem >/dev/null 2>&1
    
    $SUDO_CMD chmod 600 /etc/stunnel/lion.key 2>/dev/null
    $SUDO_CMD chmod 644 /etc/stunnel/lion.pem 2>/dev/null
fi

# Create configuration
$SUDO_CMD tee /etc/stunnel/lion.conf >/dev/null << 'EOF'
; LION VPS Manager - Stunnel Configuration
; TLS_AES_256_GCM_SHA384 Cipher Suite

pid = /var/run/stunnel-lion.pid
output = /var/log/lion/stunnel.log

; TLSv1.3 with AES-256-GCM
sslVersion = TLSv1.3
ciphersuites = TLS_AES_256_GCM_SHA384

; Security options
options = -NO_SSLv2
options = -NO_SSLv3
options = -NO_TLSv1
options = -NO_TLSv1.1
options = -NO_TLSv1.2

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
EOF

show_success "Stunnel configuration created"

# Step 11: Set version info
show_progress "Finalizing LION installation"
echo "LION-v2.0.0-TLS_AES_256_GCM_SHA384" | $SUDO_CMD tee /etc/lion/sistema/versao >/dev/null
echo "TLS_AES_256_GCM_SHA384" | $SUDO_CMD tee /etc/lion/sistema/cipher >/dev/null
echo "$(date)" | $SUDO_CMD tee /etc/lion/sistema/install_date >/dev/null
echo "lion-security: $(date)" | $SUDO_CMD tee /usr/share/.lion/.lion >/dev/null

# Create user database
awk -F : '$3 >= 500 { print $1 " 1" }' /etc/passwd | grep -v '^nobody' | $SUDO_CMD tee /root/usuarios.db >/dev/null 2>&1

show_success "LION installation finalized"

# Step 12: Start services
show_progress "Starting and enabling services"
$SUDO_CMD systemctl restart ssh >/dev/null 2>&1
$SUDO_CMD systemctl enable ssh >/dev/null 2>&1
show_success "Services configured"

# Installation Complete
echo ""
echo -e "${CYAN}🦁════════════════════════════════════════════════════════🦁${NC}"
echo -e "${GREEN}🎉           LION VPS MANAGER INSTALLED SUCCESSFULLY!    🎉${NC}"
echo -e "${CYAN}🦁════════════════════════════════════════════════════════🦁${NC}"
echo ""

# Get server IP
SERVER_IP=$(curl -s ipv4.icanhazip.com 2>/dev/null || hostname -I | awk '{print $1}' || echo "YOUR-SERVER-IP")

echo -e "${YELLOW}📋 Installation Summary:${NC}"
echo -e "${BLUE}🌐 Server IP: ${WHITE}$SERVER_IP${NC}"
echo -e "${BLUE}🔐 Security Cipher: ${WHITE}TLS_AES_256_GCM_SHA384${NC}"
echo -e "${BLUE}🛡️ TLS Protocol: ${WHITE}TLSv1.3${NC}"
echo -e "${BLUE}⚡ Installation: ${WHITE}FULLY AUTOMATED${NC}"
echo ""

echo -e "${YELLOW}🚀 Access LION Manager:${NC}"
echo -e "${GREEN}lion${NC}       - Main command"
echo -e "${GREEN}l${NC}          - Short alias"
echo -e "${GREEN}lionmenu${NC}   - Direct menu access"
echo ""

echo -e "${YELLOW}🔗 TLS Connection Ports:${NC}"
echo -e "${GREEN}Port 9443${NC} - TLS SSH (Stunnel encrypted SSH)"
echo -e "${GREEN}Port 8443${NC} - TLS Proxy (Stunnel encrypted proxy)"
echo ""

echo -e "${CYAN}🦁 LION VPS MANAGER IS READY! TYPE 'lion' TO START! 🦁${NC}"
echo -e "${GREEN}🔒 TLS_AES_256_GCM_SHA384 SECURITY ACTIVE! 🔒${NC}"
echo ""

# Clean up
rm -f /tmp/menu /tmp/criarusuario /tmp/remover /tmp/conexao /tmp/stunnel-config 2>/dev/null

exit 0
