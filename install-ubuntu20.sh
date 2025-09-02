#!/bin/bash

# LION VPS MANAGER - Ubuntu 20.04 Easy Installation Script
# TLS_AES_256_GCM_SHA384 Enhanced Security
# Auto-installer with system updates and package management

clear

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# LION Banner
echo -e "${CYAN}🦁════════════════════════════════════════════════════════🦁${NC}"
echo -e "${CYAN}🦁                LION VPS MANAGER INSTALLER             🦁${NC}"
echo -e "${CYAN}🦁              Ubuntu 20.04 Easy Installation          🦁${NC}"
echo -e "${CYAN}🦁════════════════════════════════════════════════════════🦁${NC}"
echo ""
echo -e "${YELLOW}🔐 Security Protocol: ${GREEN}TLS_AES_256_GCM_SHA384${NC}"
echo -e "${YELLOW}📦 Target OS: ${GREEN}Ubuntu 20.04 LTS${NC}"
echo -e "${YELLOW}🛡️ Encryption: ${GREEN}TLSv1.3 with Stunnel${NC}"
echo ""

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo -e "${RED}❌ This script should NOT be run as root!${NC}"
   echo -e "${YELLOW}🦁 Please run as a regular user with sudo privileges.${NC}"
   exit 1
fi

# Check Ubuntu version
if ! grep -q "20.04" /etc/os-release; then
    echo -e "${RED}⚠️ Warning: This installer is optimized for Ubuntu 20.04${NC}"
    echo -e "${YELLOW}🦁 Continue anyway? [y/N]: ${NC}"
    read -r continue_install
    if [[ ! "$continue_install" =~ ^[Yy]$ ]]; then
        echo -e "${RED}❌ Installation cancelled.${NC}"
        exit 1
    fi
fi

# Progress function
show_progress() {
    echo -e "${BLUE}🔄 $1...${NC}"
}

# Success function
show_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Error function
show_error() {
    echo -e "${RED}❌ $1${NC}"
}

echo -e "${YELLOW}🦁 Ready to install LION VPS Manager? [Y/n]: ${NC}"
read -r install_confirm
if [[ "$install_confirm" =~ ^[Nn]$ ]]; then
    echo -e "${RED}❌ Installation cancelled.${NC}"
    exit 0
fi

echo ""
echo -e "${CYAN}🚀 Starting LION VPS Manager Installation...${NC}"
echo ""

# Step 1: System Update
show_progress "Updating system packages (This may take a few minutes)"
sudo apt update -y > /dev/null 2>&1
if [ $? -eq 0 ]; then
    show_success "System package list updated"
else
    show_error "Failed to update package list"
    exit 1
fi

show_progress "Upgrading system packages (This may take several minutes)"
sudo apt upgrade -y > /dev/null 2>&1
if [ $? -eq 0 ]; then
    show_success "System packages upgraded"
else
    show_error "Failed to upgrade packages"
    exit 1
fi

# Step 2: Install Essential Packages
show_progress "Installing essential packages"
essential_packages=(
    "curl" "wget" "git" "nano" "unzip" "screen" "htop"
    "net-tools" "lsof" "bc" "dos2unix" "jq" "figlet"
    "openssl" "ssl-cert" "ca-certificates"
)

for package in "${essential_packages[@]}"; do
    if ! dpkg -l | grep -q "^ii.*$package "; then
        sudo apt install -y "$package" > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}  ✓ $package installed${NC}"
        else
            echo -e "${RED}  ✗ Failed to install $package${NC}"
        fi
    else
        echo -e "${YELLOW}  ✓ $package already installed${NC}"
    fi
done

# Step 3: Install SSH and Security Packages
show_progress "Installing SSH and security packages"
security_packages=("openssh-server" "ufw" "fail2ban")

for package in "${security_packages[@]}"; do
    sudo apt install -y "$package" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}  ✓ $package installed${NC}"
    else
        echo -e "${RED}  ✗ Failed to install $package${NC}"
    fi
done

# Step 4: Install Stunnel for TLS
show_progress "Installing Stunnel4 for TLS_AES_256_GCM_SHA384"
sudo apt install -y stunnel4 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    show_success "Stunnel4 installed successfully"
    
    # Enable stunnel
    sudo sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4 2>/dev/null
    echo -e "${GREEN}  ✓ Stunnel enabled${NC}"
else
    show_error "Failed to install Stunnel4"
    exit 1
fi

# Step 5: Install Python3 and Pip
show_progress "Installing Python3 and essential Python packages"
sudo apt install -y python3 python3-pip > /dev/null 2>&1
pip3 install --user speedtest-cli cryptography > /dev/null 2>&1
if [ $? -eq 0 ]; then
    show_success "Python3 and packages installed"
else
    show_error "Failed to install Python packages"
fi

# Step 6: Configure Firewall
show_progress "Configuring UFW firewall for LION ports"
sudo ufw --force enable > /dev/null 2>&1
sudo ufw allow 22/tcp > /dev/null 2>&1      # SSH
sudo ufw allow 80/tcp > /dev/null 2>&1      # HTTP
sudo ufw allow 443/tcp > /dev/null 2>&1     # HTTPS
sudo ufw allow 8443/tcp > /dev/null 2>&1    # TLS Proxy
sudo ufw allow 9443/tcp > /dev/null 2>&1    # TLS SSH
sudo ufw allow 7443/tcp > /dev/null 2>&1    # TLS VPN
show_success "Firewall configured with LION TLS ports"

# Step 7: Download and Install LION Manager
show_progress "Downloading LION VPS Manager from GitHub"
cd /tmp
if wget -q https://raw.githubusercontent.com/mkkelati/lion/main/lion; then
    show_success "LION Manager downloaded"
    chmod +x lion
    
    # Run LION installer
    show_progress "Running LION VPS Manager installer"
    sudo ./lion
    
    if [ $? -eq 0 ]; then
        show_success "LION VPS Manager installed successfully"
    else
        show_error "LION installation failed"
        exit 1
    fi
else
    show_error "Failed to download LION Manager"
    echo -e "${YELLOW}🦁 Please check your internet connection and try again.${NC}"
    exit 1
fi

# Step 8: Final Configuration
show_progress "Finalizing LION configuration"

# Create LION directories
sudo mkdir -p /etc/lion/{install,modulos,sistema} > /dev/null 2>&1
sudo mkdir -p /var/log/lion > /dev/null 2>&1
sudo mkdir -p /etc/stunnel > /dev/null 2>&1

# Set version and cipher info
echo "LION-v2.0.0-TLS_AES_256_GCM_SHA384" | sudo tee /etc/lion/sistema/versao > /dev/null
echo "TLS_AES_256_GCM_SHA384" | sudo tee /etc/lion/sistema/cipher > /dev/null
echo "$(date)" | sudo tee /etc/lion/sistema/install_date > /dev/null

show_success "LION configuration completed"

# Step 9: Service Status Check
show_progress "Checking service status"
if systemctl is-active --quiet ssh; then
    echo -e "${GREEN}  ✓ SSH service is running${NC}"
else
    echo -e "${RED}  ✗ SSH service not running${NC}"
    sudo systemctl start ssh
fi

if systemctl is-enabled --quiet ufw; then
    echo -e "${GREEN}  ✓ UFW firewall is enabled${NC}"
else
    echo -e "${YELLOW}  ⚠ UFW firewall not enabled${NC}"
fi

# Installation Complete
echo ""
echo -e "${CYAN}🦁════════════════════════════════════════════════════════🦁${NC}"
echo -e "${GREEN}🎉           LION VPS MANAGER INSTALLATION COMPLETE!     🎉${NC}"
echo -e "${CYAN}🦁════════════════════════════════════════════════════════🦁${NC}"
echo ""

# Get server IP
SERVER_IP=$(curl -s ipv4.icanhazip.com 2>/dev/null || echo "YOUR-SERVER-IP")

echo -e "${YELLOW}📋 Installation Summary:${NC}"
echo -e "${BLUE}🌐 Server IP: ${WHITE}$SERVER_IP${NC}"
echo -e "${BLUE}🔐 Security Cipher: ${WHITE}TLS_AES_256_GCM_SHA384${NC}"
echo -e "${BLUE}🛡️ TLS Protocol: ${WHITE}TLSv1.3${NC}"
echo -e "${BLUE}📦 OS Version: ${WHITE}$(lsb_release -d | cut -f2)${NC}"
echo ""

echo -e "${YELLOW}🚀 How to Access LION Manager:${NC}"
echo -e "${GREEN}lion${NC}       - Main command"
echo -e "${GREEN}l${NC}          - Short alias"
echo -e "${GREEN}lionmenu${NC}   - Direct menu access"
echo ""

echo -e "${YELLOW}🔗 TLS Connection Ports:${NC}"
echo -e "${GREEN}Port 9443${NC} - TLS SSH (Stunnel encrypted SSH)"
echo -e "${GREEN}Port 8443${NC} - TLS Proxy (Stunnel encrypted proxy)"
echo -e "${GREEN}Port 7443${NC} - TLS VPN (Stunnel encrypted VPN)"
echo ""

echo -e "${YELLOW}⚡ Quick Start:${NC}"
echo -e "${WHITE}1.${NC} Run: ${GREEN}lion${NC}"
echo -e "${WHITE}2.${NC} Select: ${GREEN}[06] Configure Stunnel TLS${NC}"
echo -e "${WHITE}3.${NC} Choose: ${GREEN}[1] Quick Setup${NC}"
echo -e "${WHITE}4.${NC} Create users with: ${GREEN}[01] Create SSH User${NC}"
echo ""

echo -e "${YELLOW}📞 Support:${NC}"
echo -e "${BLUE}🐱 GitHub: ${WHITE}https://github.com/mkkelati/lion${NC}"
echo -e "${BLUE}📱 Telegram: ${WHITE}@LION_VPS_MANAGER${NC}"
echo ""

echo -e "${CYAN}🦁 ROAR WITH CONFIDENCE! LION VPS MANAGER IS READY! 🦁${NC}"
echo -e "${GREEN}🔒 TLS_AES_256_GCM_SHA384 SECURITY PROTOCOL ACTIVE! 🔒${NC}"
echo ""

# Clean up
rm -f /tmp/lion

exit 0
