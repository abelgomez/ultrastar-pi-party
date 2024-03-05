#!/bin/bash -e

# Clone, build, install and clean up keymapper
on_chroot << EOF
if [ ! -e /usr/local/bin/keymapper ]; then
    if [ ! -e keymapper ]; then
        git clone https://github.com/houmain/keymapper
    fi
    cd keymapper
    cmake -B build
    cmake --build build
    cp build/keymapper build/keymapperd /usr/local/bin
    cd ..
fi
EOF

# Setup keymapper services
install -D -m 644 files/keymapper.service "${ROOTFS_DIR}/etc/systemd/system/keymapper.service"
install -D -m 644 files/keymapperd.service "${ROOTFS_DIR}/etc/systemd/system/keymapperd.service"
install -D -m 644 files/keymapper.conf "${ROOTFS_DIR}/etc/keymapper.conf"

on_chroot << EOF
systemctl enable keymapper.service
systemctl enable keymapperd.service
EOF

# Cleanup
on_chroot << EOF
rm -rf keymapper
apt -y purge build-essential \
    git \
    cmake
apt -y autoremove
EOF