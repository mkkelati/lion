# 🦁 LION VPS MANAGER 🦁

## Advanced SSH/Stunnel Manager with TLS_AES_256_GCM_SHA384 Encryption

### ✨ Features

🦁 **LION VPS MANAGER** is a professional SSH connection management system built with advanced TLS encryption using the **TLS_AES_256_GCM_SHA384** cipher suite.

### 🔐 Security Features

- **TLSv1.3 Enforcement** - Only the latest TLS protocol
- **TLS_AES_256_GCM_SHA384** - Military-grade cipher suite
- **Advanced SSH Hardening** - Modern SSH security configurations
- **Certificate Management** - Automated TLS certificate generation
- **Connection Monitoring** - Real-time user and TLS connection tracking

### 🚀 Key Components

#### 📊 **User Management**
- Create SSH users with TLS encryption support
- Set connection limits and expiry dates
- Password management with secure generation
- User monitoring and session control

#### 🔒 **Stunnel TLS Configuration**
- Automated Stunnel setup with TLS_AES_256_GCM_SHA384
- Multiple TLS ports (SSH, Proxy, VPN)
- Certificate generation and management
- Service control and monitoring

#### 📈 **Monitoring & Analytics**
- Real-time connection monitoring
- TLS connection statistics
- User limit enforcement
- Process and network monitoring

#### ⚙️ **System Tools**
- System optimization
- Service management
- Log viewing and analysis
- Backup and restore functionality

### 🛠️ Installation

```bash
# Update system packages
apt-get update -y && apt-get upgrade -y

# Download and install LION Manager
wget https://raw.githubusercontent.com/your-repo/LION-VPS-MANAGER/main/lion
chmod +x lion
./lion
```

### 🎯 Quick Start

After installation, access LION Manager using:

```bash
# Main commands
lion       # Primary command
l          # Short alias
lionmenu   # Direct menu access
```

### 🔗 TLS Connection Details

**Default TLS Ports:**
- **9443** - TLS SSH (Stunnel encrypted SSH)
- **8443** - TLS Proxy (Stunnel encrypted proxy)
- **7443** - TLS VPN (Stunnel encrypted VPN)

**Security Protocol:**
- **Cipher Suite:** TLS_AES_256_GCM_SHA384
- **Protocol:** TLSv1.3 only
- **Key Size:** 4096-bit RSA
- **Certificate:** Auto-generated or custom

### 📋 Menu Options

```
🦁 LION VPS MANAGER - MAIN MENU 🦁

👥 USER MANAGEMENT:
[01] • Create SSH User
[02] • Remove SSH User
[03] • Change User Password
[04] • Change User Limit
[05] • User Details

🔒 TLS/STUNNEL MANAGEMENT:
[06] • Configure Stunnel TLS
[07] • Start Stunnel Service
[08] • Stop Stunnel Service
[09] • Restart Stunnel Service
[10] • Generate TLS Certificates

📊 MONITORING & TOOLS:
[11] • Monitor Connections
[12] • System Information
[13] • Speed Test
[14] • Security Settings
[15] • Backup/Restore Users

⚙️ SYSTEM TOOLS:
[16] • Update LION Manager
[17] • Restart Services
[18] • System Optimization
[19] • View Logs
[00] • Exit
```

### 🔧 Configuration Files

```
/etc/lion/
├── install/          # Installation components
├── modulos/          # Core modules
│   ├── menu          # Main menu system
│   ├── criarusuario  # User creation
│   ├── conexao       # Connection monitor
│   └── stunnel-config # TLS configuration
└── sistema/          # System files
    └── versao        # Version information

/etc/stunnel/
├── lion.conf         # Stunnel configuration
├── lion.pem          # TLS certificate
└── lion.key          # Private key

/var/log/lion/
├── stunnel.log       # Stunnel logs
└── users.log         # User management logs
```

### 🌐 Connection Examples

#### TLS SSH Connection
```bash
# Using Stunnel client
stunnel-client -connect your-server:9443

# Or configure your SSH client to use TLS tunnel
ssh -p 9443 username@your-server
```

#### TLS Proxy Connection
```bash
# Configure proxy client to use TLS
proxy_server: your-server:8443
protocol: HTTPS/TLS
cipher: TLS_AES_256_GCM_SHA384
```

### ⚡ Performance

- **High Performance:** Optimized for minimal resource usage
- **Scalable:** Supports hundreds of concurrent TLS connections
- **Efficient:** Advanced caching and connection pooling
- **Secure:** Zero-trust security model with TLS encryption

### 🔒 Security Benefits

#### **TLS_AES_256_GCM_SHA384 Advantages:**
- **256-bit AES encryption** - Industry standard encryption
- **GCM mode** - Authenticated encryption
- **SHA-384 hashing** - Strong cryptographic hashing
- **Forward secrecy** - Perfect forward secrecy protection
- **AEAD support** - Authenticated encryption with associated data

#### **TLSv1.3 Benefits:**
- **Faster handshakes** - Reduced connection time
- **Improved security** - Removed vulnerable algorithms
- **Better performance** - Optimized for modern systems
- **Future-proof** - Latest TLS standard

### 📞 Support

- **Telegram:** @LION_VPS_MANAGER
- **Version:** 2.0.0-TLS
- **License:** GPL-3.0
- **Compatibility:** Ubuntu/Debian, CentOS/RHEL

### 🚨 Security Notice

This manager enforces strict TLS security:
- Only TLSv1.3 connections allowed
- Weak ciphers automatically disabled
- Certificate verification enforced
- Regular security updates recommended

### 🦁 LION Power

**LION VPS MANAGER** combines the power and reliability of a lion with cutting-edge TLS encryption technology. Built for system administrators who demand both security and performance.

---

## 🛡️ **TLS_AES_256_GCM_SHA384 - Maximum Security Guaranteed** 🛡️

*Roar with confidence using LION VPS Manager!* 🦁
