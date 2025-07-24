#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
apt-get update

sudo apt purge -y \
  libreoffice* printer* ubiquity* mono* \
  --auto-remove

sudo apt autoremove -y

apt-get upgrade -y
# apt-get install -y \
#     curl \
#     wget \
#     git \
#     vim \
#     htop \
#     build-essential \
#     cmake \
#     python3-dev \
#     python3-pip \
#     python3-setuptools \
#     nodejs \
#     npm \
#     docker.io \
#     openssh-server \
#     can-utils \
#     i2c-tools \
#     net-tools \
#     wireless-tools \
#     network-manager

# # Install Python packages
# pip3 install \
#     numpy \
#     opencv-python \
#     flask \
#     requests \
#     pyyaml

# Clean up
apt-get clean
rm -rf /var/lib/apt/lists/*