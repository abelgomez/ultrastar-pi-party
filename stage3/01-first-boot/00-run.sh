#!/bin/bash -e

sed -i "s/quiet/silent quiet systemd.show_status=0 loglevel=0/" "${ROOTFS_DIR}/boot/cmdline.txt"

# Setup services
install -D -m 644 files/first-boot.service "${ROOTFS_DIR}/etc/systemd/system/first-boot.service"
install -D -m 744 files/grow-sdcard "${ROOTFS_DIR}/usr/lib/ultrastar-sys-mods/grow-sdcard"

# Enable services
on_chroot << EOF
systemctl enable first-boot.service
systemctl disable getty@tty1.service
EOF
