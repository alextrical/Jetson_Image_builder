# Jetson Orin Nano SD Card Image Builder

Automated GitHub Actions workflow to build custom SD card images for NVIDIA Jetson Orin Nano Developer Kit using L4T (Linux for Tegra) 36.4.3.

## Features

- **Fully Automated**: Complete CI/CD pipeline using GitHub Actions
- **L4T 36.4.3**: Latest stable release with JetPack 6.2 support
- **Custom Packages**: Install additional software packages
- **NVIDIA Binaries**: Automatic application of proprietary GPU drivers and libraries
- **Ready-to-Flash**: Generates compressed SD card images with checksums
- **Extensible**: Support for custom overlays, scripts, and configurations

## Quick Start

### 1. Fork this Repository
Click the "Fork" button to create your own copy of this repository.

### 2. Trigger a Build
- **Automatic**: Push to `main` branch or create a pull request
- **Manual**: Go to Actions "Build Jetson Orin Nano SD Card Image" "Run workflow"

### 3. Download and Flash
1. Download the compressed image from Actions artifacts or Releases
2. Extract: `xz -d jetson-orin-nano-image.img.xz`
3. Flash to SD card: `sudo dd if=jetson-orin-nano-image.img of=/dev/sdX bs=4M status=progress`
4. Insert SD card into Jetson Orin Nano and power on

## Default Configuration

- **OS**: Ubuntu 22.04 LTS ARM64
- **User**: `jetson` / `jetson` (change on first login)
- **SSH**: Enabled by default
- **Network**: NetworkManager for WiFi and Ethernet
- **Development**: Git, build tools, Python 3, I2C/SPI tools included

## Customization

### Custom Packages

Create `config/custom-packages.list` with packages to install:

```
# Development tools
python3-opencv
python3-numpy
python3-matplotlib

# System utilities
htop
tree
vim

# Libraries
libopencv-dev
libeigen3-dev
```

### Custom Files and Configurations

Create a `rootfs-overlay/` directory to add files to the root filesystem:

```
rootfs-overlay/
    etc/
        systemd/
            system/
                my-service.service
    home/
        jetson/
            scripts/
                README.txt
    usr/
        local/
            bin/
                my-script.sh
```

### Custom Scripts

Place additional scripts in `scripts/` directory for advanced customization.

## Build Configuration

### Workflow Inputs

When running manually, you can customize:

- **L4T Version**: L4T release version (default: 36.4.3)
- **Custom Packages**: Space-separated list of additional packages
- **Username**: Default user account name (default: jetson)

### Environment Variables

Modify `.github/workflows/jetson-build.yml` to change:

```yaml
env:
  L4T_VERSION: '36.4.3'
  DEFAULT_USERNAME: 'jetson'
  BSP_URL: 'https://developer.nvidia.com/downloads/...'
  ROOTFS_URL: 'https://developer.nvidia.com/downloads/...'
```

## Hardware Requirements

### Target Device
- NVIDIA Jetson Orin Nano Developer Kit (4GB or 8GB)
- 64GB+ Class 10 SD card (recommended)
- HDMI display, USB keyboard/mouse for initial setup
- Ethernet or WiFi connectivity

### Build Requirements
- GitHub Actions runner (automatically provided)
- ~20GB temporary disk space during build
- Internet connectivity for downloads

## Build Process Details

The automated build process:

1. **Environment Setup**: Configures Ubuntu runner with ARM64 emulation
2. **Component Download**: Downloads L4T BSP and Sample Root Filesystem
3. **Extraction**: Unpacks components into proper structure
4. **Package Installation**: Installs custom packages via chroot
5. **Binary Application**: Applies NVIDIA proprietary drivers and libraries
6. **System Configuration**: Creates user account and configures services
7. **Image Creation**: Generates bootable SD card image
8. **Compression**: Creates compressed artifacts with checksums

## Troubleshooting

### Build Failures

**QEMU Issues**:
```bash
# Check QEMU ARM64 support
ls -la /proc/sys/fs/binfmt_misc/
cat /proc/sys/fs/binfmt_misc/qemu-aarch64
```

**Disk Space**:
- Build requires ~20GB temporary space
- GitHub Actions runners have limited space
- Cleanup is automatic on completion

**Download Problems**:
- NVIDIA URLs may change between releases
- Check [NVIDIA Developer Downloads](https://developer.nvidia.com/embedded/downloads) for updates
- Update URLs in workflow file if needed

### Runtime Issues

**Boot Problems**:
- Verify SD card is properly flashed and not corrupted
- Check SD card compatibility (64GB+ Class 10 recommended)
- Ensure proper power supply (5V 3A minimum)

**SSH Access**:
```bash
# Default credentials
username: jetson
password: jetson

# Enable SSH if disabled
sudo systemctl enable ssh
sudo systemctl start ssh
```

**Network Configuration**:
```bash
# WiFi setup
nmtui

# Check network status
nmcli device status
```

### Hardware Issues

**GPIO Access**:
```bash
# Add user to gpio group
sudo usermod -a -G gpio jetson

# Install GPIO tools
sudo apt install python3-lgpio
```

**I2C/SPI**:
```bash
# Enable interfaces
sudo jetson-io

# Test I2C
i2cdetect -y -r 1
```

## Development

### Local Building

For local development and testing:

```bash
# Clone repository
git clone https://github.com/yourusername/jetson-orin-nano-builder
cd jetson-orin-nano-builder

# Build with Docker (optional)
docker build -t jetson-builder .
docker run -v $(pwd):/workspace jetson-builder
```

### Testing Changes

1. Create feature branch: `git checkout -b feature/my-change`
2. Make changes to workflow or configuration
3. Push and create pull request
4. GitHub Actions will test the build automatically

## Advanced Configuration

### Multi-board Support

To support multiple Jetson boards, modify the workflow:

```yaml
strategy:
  matrix:
    board: [jetson-orin-nano-devkit, jetson-orin-nx-devkit]
    l4t_version: [36.4.3, 36.3.0]
```

### Custom Kernel

To use a custom kernel:

1. Add kernel source to repository
2. Modify workflow to build kernel before image creation
3. Update device tree configurations as needed

### Security Hardening

Additional security configurations:

```bash
# Disable password authentication
sudo sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Configure firewall
sudo ufw enable
sudo ufw allow ssh
```

## Performance Optimization

### Image Size Reduction

- Remove unused packages in `custom-packages.list`
- Clean package caches: `apt-get clean && rm -rf /var/lib/apt/lists/*`
- Remove development headers if not needed

### Build Time Optimization

- Use GitHub Actions cache for downloaded components
- Parallel processing where possible
- Incremental builds for development

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with a pull request build
5. Submit pull request with description

### Code Style

- Use shellcheck for shell scripts
- Follow YAML best practices for workflows
- Document all configuration options
- Include error handling and logging

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Resources

- [NVIDIA Jetson Developer Guide](https://docs.nvidia.com/jetson/)
- [L4T Documentation](https://docs.nvidia.com/jetson/l4t/)
- [JetPack SDK](https://developer.nvidia.com/embedded/jetpack)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

## Support

- Create an issue for bugs or feature requests
- Check existing issues for solutions
- Join the [NVIDIA Developer Forums](https://forums.developer.nvidia.com/c/agx-autonomous-machines/jetson-embedded-systems/)

## Changelog

### v1.0.0
- Initial release with L4T 36.4.3 support
- Automated GitHub Actions workflow
- Custom package installation support
- NVIDIA proprietary binary integration
- Comprehensive documentation and troubleshooting guides