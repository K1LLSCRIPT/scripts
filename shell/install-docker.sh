#!/usr/bin/env bash

deps=(
  sudo
  curl
  ca-certificates
);

check_deps() {
  local need=();

  for pkg in "${deps[@]}"; do
    apt list --installed "$pkg" 2>/dev/null | grep -q installed || need+=("$pkg");
  done;

  (( ${#need[@]} )) && { apt update; apt install -y "${need[@]}"; }
}

check_deps;

sudo apt remove -y $(dpkg --get-selections docker.io docker-compose docker-doc docker-buildx podman-docker containerd runc | cut -f1);

sudo apt update;
sudo install -m 0755 -d /etc/apt/keyrings;
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc;
sudo chmod a+r /etc/apt/keyrings/docker.asc;

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update;
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin;

echo -e "\ndone";
exit 0;
