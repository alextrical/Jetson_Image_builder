# Troubleshooting Guide

## Common Build Issues

### 1. "apply_binaries.sh failed"

**Problem**: The NVIDIA binary application script fails during build.

**Solutions**:
```bash
# Check if QEMU is properly installed
sudo apt-get install qemu-user-static binfmt-support
sudo update-binfmts --enable qemu-aarch64

# Verify rootfs permissions
sudo chown -R root:root Linux_for_Tegra/rootfs/
```

### 2. "Cannot download L4T packages"

**Problem**: Downloads fail or URLs are not accessible.

**Solutions**:
- Check NVIDIA developer account access
- Verify URLs are current (NVIDIA occasionally changes them)
- Use VPN if corporate firewall blocks downloads
- Check GitHub Actions runner has internet access

### 3. "jetson-disk-image-creator.sh not found"

**Problem**: Image creation tool is missing.

**Solutions**:
```bash
# Ensure you extracted the full BSP package
tar -tf Jetson_Linux_r36.4.3_aarch64.tbz2 | grep jetson-disk-image-creator

# Check extraction directory
ls -la Linux_for_Tegra/tools/
```

### 4. "Insufficient disk space"

**Problem**: Build fails due to lack of space.

**Solutions**:
- GitHub Actions runners have ~14GB free
- L4T builds need ~10-12GB
- Clean up intermediate files during build
- Use compression for artifacts

### 5. "chroot: failed to run command"

**Problem**: Package installation in chroot fails.

**Solutions**:
```bash
# Ensure binfmt is configured
ls /proc/sys/fs/binfmt_misc/
cat /proc/sys/fs/binfmt_misc/qemu-aarch64

# Check qemu-aarch64-static is in rootfs
ls -la rootfs/usr/bin/qemu-aarch64-static
```

## Runtime Issues

### 1. "Jetson won't boot from SD card"

**Symptoms**: Black screen, no boot activity.

**Solutions**:
- Verify SD card is properly flashed
- Use Class 10 or better SD card (64GB+ recommended)
- Check HDMI connection and monitor compatibility
- Try serial console connection for boot logs

### 2. "SSH connection refused"

**Symptoms**: Cannot connect via SSH.

**Solutions**:
```bash
# Check SSH service status on Jetson
sudo systemctl status ssh
sudo systemctl enable ssh
sudo systemctl start ssh

# Check firewall settings
sudo ufw status
sudo ufw allow ssh
```

### 3. "Default user cannot sudo"

**Symptoms**: Permission denied for sudo commands.

**Solutions**:
```bash
# Add user to sudo group
sudo usermod -aG sudo jetson

# Check sudoers file
sudo visudo
# Ensure this line exists: %sudo ALL=(ALL:ALL) ALL
```

### 4. "Docker not working"

**Symptoms**: Docker commands fail or service not running.

**Solutions**:
```bash
# Start Docker service
sudo systemctl enable docker
sudo systemctl start docker

# Add user to docker group
sudo usermod -aG docker jetson
# Log out and back in for group changes to take effect

# Test Docker installation
docker --version
sudo docker run hello-world
```

### 5. "WiFi not working"

**Symptoms**: No wireless networks detected.

**Solutions**:
```bash
# Check WiFi module
lspci | grep -i wireless
lsusb | grep -i wireless

# Check NetworkManager
sudo systemctl status NetworkManager
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

# Scan for networks
sudo iwlist scan
nmcli dev wifi list
```

## Performance Issues

### 1. "Slow boot times"

**Solutions**:
- Disable unnecessary systemd services
- Use faster SD card (U3 rating recommended)
- Move to NVMe SSD for better performance

### 2. "High CPU usage after boot"

**Solutions**:
```bash
# Check running processes
htop
ps aux --sort=-%cpu | head -20

# Disable unnecessary services
sudo systemctl disable <service-name>
```

## Development Issues

### 1. "GPIO pins not accessible"

**Solutions**:
```bash
# Add user to gpio group
sudo usermod -aG gpio jetson

# Check gpio devices
ls -la /dev/gpiochip*
ls -la /sys/class/gpio/
```

### 2. "I2C/SPI not working"

**Solutions**:
```bash
# Enable I2C/SPI interfaces
sudo jetson-io

# Check device nodes
ls -la /dev/i2c*
ls -la /dev/spidev*

# Install utilities
sudo apt install i2c-tools spi-tools
```

### 3. "Camera not detected"

**Solutions**:
```bash
# Check V4L2 devices
ls -la /dev/video*
v4l2-ctl --list-devices

# Test camera
gst-launch-1.0 v4l2src device=/dev/video0 ! xvimagesink
```

## Debug Commands

### System Information
```bash
# L4T version
cat /etc/nv_tegra_release

# Kernel version
uname -a

# Hardware info
sudo tegrastats
sudo nvpmodel -q

# GPU info
nvidia-smi  # May not be available on Nano

# Memory usage
free -h
df -h
```

### Network Diagnostics
```bash
# Network interfaces
ip addr show
ifconfig

# DNS resolution
nslookup google.com
dig google.com

# Connectivity
ping -c 4 8.8.8.8
curl -I https://www.nvidia.com
```

### Service Diagnostics
```bash
# Check all services
sudo systemctl status

# Check failed services
sudo systemctl --failed

# View service logs
sudo journalctl -u <service-name>
sudo journalctl -f  # Follow logs
```

## Getting Help

### Official Resources
- [NVIDIA Developer Forums](https://forums.developer.nvidia.com/c/agx-autonomous-machines/jetson-embedded-systems/)
- [Jetson Linux Developer Guide](https://docs.nvidia.com/jetson/l4t/)
- [JetPack Documentation](https://docs.nvidia.com/jetpack/)

### Community Resources
- [JetsonHacks](https://jetsonhacks.com/)
- [NVIDIA Jetson AI Lab](https://www.jetson-ai-lab.com/)
- [r/JetsonNano Subreddit](https://www.reddit.com/r/JetsonNano/)

### Debug Information to Include
When seeking help, please provide:
- Exact error messages
- L4T version (`cat /etc/nv_tegra_release`)
- Hardware model (Orin Nano 4GB/8GB)
- Steps to reproduce the issue
- Relevant log files (`journalctl`, `dmesg`)