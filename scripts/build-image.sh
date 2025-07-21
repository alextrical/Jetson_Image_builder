#!/bin/bash
set -e

# Jetson Orin Nano SD Card Image Build Script
# This script builds a custom SD card image for Jetson Orin Nano

# Configuration
L4T_VERSION="36.4.3"
WORKSPACE="/workspace"
BUILD_DIR="$WORKSPACE/build"

echo "Starting Jetson Orin Nano SD Card Image Build"
echo "L4T Version: $L4T_VERSION"
echo "Workspace: $WORKSPACE"

# Create build directory
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Step 1: Download L4T components
echo "Downloading L4T components..."
if [ ! -f "Jetson_Linux_r${L4T_VERSION}_aarch64.tbz2" ]; then
    wget -O "Jetson_Linux_r${L4T_VERSION}_aarch64.tbz2" \
        "https://developer.nvidia.com/downloads/embedded/l4t/r36_release_v4.3/release/Jetson_Linux_r${L4T_VERSION}_aarch64.tbz2"
fi

if [ ! -f "Tegra_Linux_Sample-Root-Filesystem_r${L4T_VERSION}_aarch64.tbz2" ]; then
    wget -O "Tegra_Linux_Sample-Root-Filesystem_r${L4T_VERSION}_aarch64.tbz2" \
        "https://developer.nvidia.com/downloads/embedded/l4t/r36_release_v4.3/release/Tegra_Linux_Sample-Root-Filesystem_r${L4T_VERSION}_aarch64.tbz2"
fi

# Step 2: Extract packages
echo "Extracting L4T packages..."
tar -xf "Jetson_Linux_r${L4T_VERSION}_aarch64.tbz2"
cd Linux_for_Tegra/rootfs/
sudo tar -xpf "../../Tegra_Linux_Sample-Root-Filesystem_r${L4T_VERSION}_aarch64.tbz2"
cd ../..

# Step 3: Apply custom configurations
echo "Applying custom configurations..."
if [ -f "$WORKSPACE/config/custom-packages.list" ]; then
    echo "Installing custom packages..."
    # Add custom package installation logic here
fi

# Step 4: Apply NVIDIA binaries
echo "Applying NVIDIA proprietary binaries..."
cd Linux_for_Tegra
sudo ./apply_binaries.sh

# Step 5: Create default user
echo "Creating default user..."
sudo ./tools/l4t_create_default_user.sh \
    -u jetson \
    -p jetson \
    -a \
    -n jetson-orin-nano \
    --accept-license

# Step 6: Generate SD card image
echo "Generating SD card image..."
cd tools
IMAGE_NAME="${IMAGE_NAME:-jetson-orin-nano-$(date +%Y%m%d_%H%M%S)}.img"
sudo ./jetson-disk-image-creator.sh \
    -o "$IMAGE_NAME" \
    -b jetson-orin-nano-devkit \
    -d SD \
    -r 300

echo "Build completed successfully!"
echo "Image created: $IMAGE_NAME"