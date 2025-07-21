FROM ubuntu:22.04 as jetson-builder

# Install dependencies for L4T build
RUN apt-get update && apt-get install -y \
    wget curl tar bzip2 lbzip2 \
    python3 python3-pip \
    qemu-user-static binfmt-support \
    debootstrap parted kpartx gdisk \
    dosfstools e2fsprogs sudo rsync \
    bc build-essential device-tree-compiler \
    && rm -rf /var/lib/apt/lists/*

# Set up workspace
WORKDIR /workspace

# Copy build scripts
COPY scripts/ ./scripts/
COPY config/ ./config/

# Make scripts executable
RUN chmod +x scripts/*.sh

# Default command
CMD ["./scripts/build-image.sh"]
