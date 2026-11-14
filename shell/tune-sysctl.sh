#!/usr/bin/env bash

cat << 'EOF' > /etc/sysctl.d/99-custom.conf
net.core.default_qdisc = fq
net.core.somaxconn = 65535
net.core.netdev_max_backlog = 250000

net.core.rmem_default = 212992
net.core.wmem_default = 212992

#net.core.rmem_max = 8388608
#net.core.wmem_max = 8388608

net.ipv4.udp_rmem_min = 4096
net.ipv4.udp_wmem_min = 4096

net.ipv4.tcp_rmem = 4096 87380 4194304
net.ipv4.tcp_wmem = 4096 65536 4194304

net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 15

net.ipv4.tcp_congestion_control = bbr
net.ipv4.tcp_syncookies = 2
net.ipv4.tcp_fastopen = 3
net.ipv4.ip_forward = 1

# if error, try:
# [[ ! $(grep nf_conntrack_ftp /etc/modules-load.d/modules.conf) ]] && { echo "nf_conntrack_ftp" >> /etc/modules-load.d/modules.conf; modprobe nf_conntrack; modprobe ip_conntrack; }

net.nf_conntrack_max = 262144
net.netfilter.nf_conntrack_max = 262144

net.netfilter.nf_conntrack_max=1048576
net.netfilter.nf_conntrack_buckets=262144
net.netfilter.nf_conntrack_udp_timeout=30
#net.netfilter.nf_conntrack_udp_stream=180


net.core.netdev_max_backlog=250000
#net.ipv4.udp_mem='8388608 12582912 16777216'
net.ipv4.udp_rmem_min=8192
net.ipv4.udp_wmem_min=8192
net.core.rmem_max=16777216
net.core.wmem_max=16777216

net.ipv6.conf.default.forwarding=1

#net.ipv6.conf.all.disable_ipv6 = 0
#net.ipv6.conf.default.disable_ipv6 = 0

vm.overcommit_memory = 1
EOF

sysctl --system

echo -e "\ndone";
exit 0;
