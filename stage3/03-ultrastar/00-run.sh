#!/bin/bash -e

install -D -m 744 files/check-mic-connected "${ROOTFS_DIR}/usr/lib/ultrastar-sys-mods/check-mic-connected"
install -D -m 744 files/on-ultrastar-exit "${ROOTFS_DIR}/usr/lib/ultrastar-sys-mods/on-ultrastar-exit"

install -D -m 644 files/mnt-sdcard.mount "${ROOTFS_DIR}/etc/systemd/system/mnt-sdcard.mount"
install -D -m 644 files/ultrastar.service "${ROOTFS_DIR}/etc/systemd/system/ultrastar.service"

# Enable services
on_chroot << EOF
systemctl enable ultrastar.service
EOF


# Fix FPC configuration
on_chroot << EOF
if ! grep -q "/usr/lib/gcc/aarch64-linux-gnu/10" /etc/fpc.cfg; then
    echo "-Fl/usr/lib/gcc/aarch64-linux-gnu/10" >> /etc/fpc.cfg
fi
EOF

# Clone, build, install and clean up Ultrastar World Party
on_chroot << EOF
if [ ! -e /usr/local/bin/WorldParty ]; then
    if [ ! -e ultrastar-worldparty ]; then
        git clone https://github.com/ultrastares/ultrastar-worldparty.git
    fi
    cd ultrastar-worldparty
    ./autogen.sh
    ./configure
    make
    make install
    cd ..
fi
EOF

# Enable automatic shutdown when leaving Ultrastar
on_chroot << EOF
touch /boot/shutdown.enabled
EOF

# Setup SD-Card files
on_chroot << EOF
mkdir -p /mnt/sdcard/Ultrastar/.ultrastar-worldparty
echo "[Directories]" > /mnt/sdcard/Ultrastar/.ultrastar-worldparty/config.ini
echo "SongDir1=/mnt/sdcard/Ultrastar/Songs" >> /mnt/sdcard/Ultrastar/.ultrastar-worldparty/config.ini
if [ ! -e /mnt/sdcard/Ultrastar/Songs ]; then
    cd /mnt/sdcard/Ultrastar/
    wget https://github.com/UltraStar-Deluxe/songs/archive/refs/heads/master.zip
    unzip -o master.zip
    mv "songs-master/Creative Commons" "Songs"
    rm -rf master.zip songs-master
fi
cd /
EOF

# Setup ultrastar user
on_chroot << EOF
if ! id ultrastar &> /dev/null; then
    useradd -M -d /mnt/sdcard/Ultrastar -U -s /sbin/nologin -G audio,video,input ultrastar
fi
EOF

# Cleanup
on_chroot << EOF
rm -rf ultrastar-worldparty
apt -y purge fpc \
    git \
    automake \
    make \
    gcc
apt -y autoremove
EOF
