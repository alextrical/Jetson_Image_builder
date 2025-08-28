#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
apt-get update



# install all latest packages
# apt-get upgrade -y

# Clean up
apt-get autoremove -y
apt-get autoclean
apt-get clean
rm -rf /var/lib/apt/lists/* \
  /tmp/ \
  /var/tmp/* \
  ~/.cache/thumbnails/