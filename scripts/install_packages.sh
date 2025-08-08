#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
apt-get update


#Install dependencies for future steps
## apt-get upgrade -y
apt-get install -y \
    curl \
    wget \
    python3-pip \
    python3-setuptools \
    python3-wheel \
    git \
    alsa-utils \
    ffmpeg \
    ca-certificates \
    apt-utils


#remove applications that have no purpose to be installed on a Headless server
apt-get purge -y \
  libreoffice* \
  printer* \
  thunderbird \
  mono* \
  --auto-remove \
   2>&1 | grep -v "is not installed, so not removed"


# Install Python packages
python3 -m pip install --upgrade --user --no-warn-script-location \
    pip \
    "setuptools<71.0.0" \
    wheel \
    jetson-stats


# Install Docker
export docker_keyring_path="/usr/share/keyrings/docker-archive-keyring.gpg"
# Add Docker’s GPG key & repo for your Ubuntu release:
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update

apt-get install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin \
  nvidia-container


# Install yq
wget https://github.com/mikefarah/yq/releases/download/v4.45.4/yq_linux_arm64.tar.gz -O - \
| tar xz -C /tmp
mv /tmp/yq_linux_arm64 /usr/local/bin/yq


# Clean up
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*