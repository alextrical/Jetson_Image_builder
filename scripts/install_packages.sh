#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
apt-get update

#remove applications that have no purpose to be installed on a Headless server
apt-get purge -y \
  libreoffice* \
  printer* \
  thunderbird \
  mono* \
  --auto-remove


#Install dependencies for future steps
## apt-get upgrade -y
apt-get install -y \
    curl \
    wget \
    python3-pip \
    python3-setuptools \
    git \
    alsa-utils \
    ffmpeg


# Install Python packages
python3 -m pip install --upgrade --user \
    pip \
    "setuptools<71.0.0" \ 
    wheel \
    jetson-stats


# Install Docker
# (Re‑)add Docker’s GPG key & repo for your Ubuntu release:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor \
-o ${docker_keyring_path}
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=${docker_keyring_path}] \
https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" \
| sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update

sudo apt-get install -y \
  docker-ce=5:27.5* \
  docker-ce-cli=5:27.5* \
  nvidia-container \
  docker-compose \
  --allow-downgrades


# Install yq
wget https://github.com/mikefarah/yq/releases/download/v4.45.4/yq_linux_arm64.tar.gz -O - \
| tar xz -C /tmp
sudo mv /tmp/yq_linux_arm64 /usr/local/bin/yq


# Clean up
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*