#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
apt update



# install all latest packages
# apt upgrade -y

# Clean up
apt autoremove -y
apt autoclean
apt clean
rm -rf /var/lib/apt/lists/* \
  /tmp/ \
  /var/tmp/* \
  ~/.cache/thumbnails/