#!/bin/bash -e


install -D -m 744 files/tty1-print "${ROOTFS_DIR}/usr/local/bin/tty1-print"
install -D -m 644 files/boot-message.service "${ROOTFS_DIR}/etc/systemd/system/boot-message.service"

# Enable services
on_chroot << EOF
systemctl enable boot-message.service
EOF
