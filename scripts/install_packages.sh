#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
apt-get update

#remove applications that have no purpose to be installed on a Headless server
sudo apt-get purge -y \
  libreoffice* \
  printer* \
  thunderbird \
  mono* \
  --auto-remove

sudo apt-get autoremove -y

#Install dependencies for future steps
## apt-get upgrade -y
apt-get install -y \
    curl \
    wget \
    python3-pip \
    python3-setuptools
#     git \
#     vim \
#     htop \
#     build-essential \
#     cmake \
#     python3-dev \
#     nodejs \
#     npm \
#     docker.io \
#     openssh-server \
#     can-utils \
#     i2c-tools \
#     net-tools \
#     wireless-tools \
#     network-manager

# Install Python packages
python3 -m pip install --upgrade --user \
    pip 
    setuptools 
    wheel

# # Install Python packages
# pip3 install \
#     numpy \
#     opencv-python \
#     flask \
#     requests \
#     pyyaml

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
  docker-compose --allow-downgrades


# Clean up
apt-get clean
rm -rf /var/lib/apt/lists/*