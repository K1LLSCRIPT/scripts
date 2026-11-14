#!/usr/bin/env bash

deps=(
  sudo
  curl
  wget
  gpg
  lsof
  net-tools
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

curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | bash;

apt install -y speedtest;

echo -e "\ndone";
exit 0;
