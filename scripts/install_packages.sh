#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
apt-get update

# Install Docker keyring
export docker_keyring_path="/usr/share/keyrings/docker-archive-keyring.gpg"
# Add Docker’s GPG key & repo for your Ubuntu release:
install -m 0755 -d /etc/apt/keyrings
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the docker repository to Apt sources:
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
tee /etc/apt/sources.list.d/docker.list > /dev/null
echo "✅ Added docker repo."

#add yq repo to apt sources:
sudo add-apt-repository -y ppa:rmescandon/yq
echo "✅ Added yq repo."

sudo apt-get update
# sudo apt-get upgrade -y
sudo apt-get install -y \
    curl \
    wget \
    python3-pip \
    git \
    alsa-utils \
    ffmpeg \
    ca-certificates \
    jq \
    yq \
    openssh-client \
    nano \
    network-manager \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin \
    nvidia-container \
    --no-install-recommends
echo "✅ system packages installed."

# Install Python packages
sudo python3 -m pip install --upgrade --no-warn-script-location \
  pip \
  "setuptools<71.0.0" \
  wheel \
  jetson-stats
echo "✅ Python packages installed."

echo "{
  \"runtimes\": {
    \"nvidia\": {
      \"path\": \"nvidia-container-runtime\",
      \"runtimeArgs\": []
    }
  }
}" | sudo tee /etc/docker/daemon.json
echo "✅ Add nvidia container runtime to docker."

#disable GUI
sudo systemctl set-default multi-user.target
echo "✅ disable desktop."

#remove services
sudo systemctl disable nvzramconfig.service
sudo systemctl disable nvargus-daemon.service
sudo systemctl disable cups.service
sudo systemctl disable ModemManager.service
echo "✅ removed services."

#set user group
sudo usermod -aG sudo $OEM_USER
sudo usermod -aG nexus $OEM_USER
sudo usermod -aG docker $OEM_USER

#set Jetson Clocks
sudo tee "/etc/systemd/system/jetson_clocks.service" >/dev/null <<'EOF1'
[Unit]
Description=Jetson Clocks Service
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/usr/bin/jetson_clocks
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
EOF1
sudo systemctl enable jetson_clocks.service
echo "✅ created jetson clocks service."

# #remove applications that have no purpose to be installed on a Headless server
# apt-get purge -y \
#   libreoffice* \
#   printer* \
#   thunderbird \
#   mono* \
#   cups \
#   firefox \
#   gdm3 \
#   gnome-control-center \
#   gnome-terminal \
#   gedit \
#   cheese \
#   aisleriot \
#   gnome-mahjongg \
#   gnome-mines \
#   gnome-sudoku \
#   ubiquity \
#   --auto-remove \
#    2>&1 | grep -v "is not installed, so not removed"

# install all latest packages
# apt-get upgrade -y

# Clean up
apt-get autoremove -y
apt-get autoclean
apt-get clean
rm -rf /var/lib/apt/lists/* \
  /tmp/* \
  /var/tmp/* \
  ~/.cache/thumbnails/*