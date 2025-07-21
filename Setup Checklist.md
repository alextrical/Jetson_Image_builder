# Jetson Orin Nano SD Card Builder Setup Checklist

## Repository Setup

- [X] Create new GitHub repository
- [ ] Enable GitHub Actions in repository settings
- [X] Clone repository locally

## File Setup

- [X] Create `.github/workflows/` directory
- [X] Copy `jetson-build.yml` to `.github/workflows/`
- [ ] Copy all config files to `config/` directory
- [ ] Copy build script to `scripts/` directory
- [ ] Copy documentation files (README.md, TROUBLESHOOTING.md)

## Configuration

- [ ] Review and customize `config/custom-packages.list`
- [ ] Modify `.env.example` if using different L4T versions
- [ ] Create `rootfs-overlay/` directory for custom files
- [ ] Add any custom files/configurations to `rootfs-overlay/`

## Testing

- [ ] Commit and push initial files
- [ ] Check GitHub Actions tab for first build
- [ ] Verify workflow runs without errors
- [ ] Test manual workflow dispatch
- [ ] Create a test release tag (e.g., v1.0.0)

## Hardware Testing

- [ ] Download built SD card image
- [ ] Flash image to SD card using balenaEtcher
- [ ] Insert SD card into Jetson Orin Nano
- [ ] Verify successful boot
- [ ] Test login with jetson/jetson credentials
- [ ] Verify custom packages are installed
- [ ] Test SSH connectivity
- [ ] Verify GPIO/hardware functionality

## Customization

- [ ] Add application-specific packages to custom-packages.list
- [ ] Include application files in rootfs-overlay/
- [ ] Configure systemd services for auto-start
- [ ] Test custom GPIO/hardware configurations
- [ ] Update documentation for your specific use case

## Production Use

- [ ] Update default password in workflow
- [ ] Configure proper SSH keys
- [ ] Set up proper network configuration
- [ ] Configure automatic updates strategy
- [ ] Document deployment procedures

## Notes

- Build time: ~45-60 minutes on GitHub Actions
- Disk space required: ~20GB during build
- Final image size: ~6-8GB (compressed: ~2-3GB)
- SD card requirement: 64GB+ Class 10 or better
- Compatible hardware: Jetson Orin Nano Developer Kit (4GB/8GB)
