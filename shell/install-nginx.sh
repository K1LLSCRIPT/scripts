#!/usr/bin/env bash

apt update;
apt -y install sudo curl gnupg2 ca-certificates lsb-release debian-archive-keyring;

[[ -f /usr/share/keyrings/nginx-archive-keyring.gpg ]] && { rm -rf /usr/share/keyrings/nginx-archive-keyring.gpg; }
curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
    | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null;

gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg;

[[ -f /etc/apt/sources.list.d/nginx.list ]] && { rm -rf /etc/apt/sources.list.d/nginx.list; }
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
http://nginx.org/packages/mainline/debian `lsb_release -cs` nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list;

[[ -f /etc/apt/preferences.d/99nginx ]] && { rm -rf /etc/apt/preferences.d/99nginx; }
echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
    | sudo tee /etc/apt/preferences.d/99nginx;

apt update;

mkdir -p /etc/ssl; curl https://ssl-config.mozilla.org/ffdhe2048.txt > /etc/ssl/dhparam.pem;

apt -y install nginx nginx-module-geoip nginx-module-njs nginx-module-perl nginx-module-xslt;

exit 0;
