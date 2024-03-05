# Ultrastar Pi Party

Repository with a Raspberry Pi OS image ready to run [Ultrastar WorlParty](https://github.com/ultrastares/ultrastar-worldparty).

For further information on how these scripts work, check the documentation of the _pi-gen_ tool at https://github.com/RPi-Distro/pi-gen.

This image contains some example songs, available under a Creative Commons license at https://github.com/UltraStar-Deluxe/songs/, for testing purposes.

## Requirements

**This image requires a Raspberry Pi 4 or higher** (older/less powerful hardware versions can't execute Ultrastar WorldParty properly).

This image requires an SD card of 4 GB as the bare minimum, but almost no space free will be available for your songs library. **16 GB or higher is strongly recommended.**

## Installation and Quick Start Guide

1. Download the latest image from the [Releases section](https://github.com/abelgomez/ultrastar-pi-party/releases).

2. Flash the downloaded image in an SD card using the "Use custom" option of the [Raspberry Pi Imager](https://www.raspberrypi.com/software/). 

3. Put your newly flashed SD card in your Raspberry Pi, connect your microphones, **connect the HDMI-0 port (the HDMI port closest to the USB-C port)** to your screen, and power on your Raspberry Pi.

    In this first boot, your Raspberry Pi will reboot several times (2 or 3 times, depending on the steps needed) while it auto-configures itself. **Please, be patient, and wait for Ultrastar WorldParty UI to launch.**

4. To add your own library of songs to the SD card, exit Ultrastar WorldParty. The system will shut down. Connect your SD card to a computer, and copy your library of songs to the `Ultrastar/Songs` directory in the `ultrastar` partition (see FAQ below).

5. Once done, put again the SD card into your Raspberry Pi, and boot it normally (don't forget the microphones!). You're done!

## Default Configuration

The default values for the generated image are:

* Base system: **Debian bullseye**
* Default hostname: `ultrastar`
* Default user: `pi`
* Default password: `ultrastar`

For security purposes:

* Console login is **disabled**
* SSH is **disabled**

## Frequently Asked Questions (FAQ)

### Ultrastar WorldParty shows the splash screen, and then suddenly crashes!

Make sure you are using the HDMI-0 port (the closest to the USB-C port).

### How can I add my own songs to Ultrastart WorldParty?

The SD card should be partitioned in three different partitions:

1. `bootfs`, a FAT32 Windows partition (256MB approx.) with the boot files.
2. `rootfs`, an ext4 Linux partition (~3GB approx) with the base system files.
3. `ultrastar`, a FAT32 Windows partition (occupying the rest of the SD card) with the Ultrastar WorldParty data files. 

**Just put your Songs inside the `Ultrastar/Songs` directory in the `ultrastar` FAT32 partition.**

**IMPORTANT:** You must boot this image at least once in your Raspberry Pi to allow the Ultrastar partition to be resized to fit the whole SD card free space.

### Can I safely delete the Ultrastar/.ultrastar-worldparty directory?

**NO!** This is the directory where the Ultrastar WorldParty configuration files are stored. You should only delete it if you know how to recreate the configuration of Ultrastar WorldParty.

### How can I prevent the system from automatically shutting down when leaving Ultrastar WorldParty?

Simply rename the `shutdown.enabled` file in the `bootfs`partition to `shutdown.disabled`.

### Why does the system always check whether there are microphones connected or not before launching Ultrastar WorldParty?

Microphones aren't strictly necessary to launch Ultrastar WorldParty. Nevertheless, this is a safety check. If you try to start the karaoke mode without any microphone connected, **Ultrastar WorldParty will crash unadvertedly** and the system will automatically shut down.

### How can I log into the system?

Console and SSH login are disabled by default for security purposes. However, you can either:

* create a file named `ssh` in the `bootfs` partition to enable SSH and use the default user and password above; or

* apply a custom configuration when using the [Raspberry Pi Imager](https://www.raspberrypi.com/software/) to flash this image. You should enable SSH login, and you should configure a default user and password (or SSH key).

Once SSH has been enabled, console login can be enabled by running `systemctl enable getty@tty1.service`, but it is not recommended.

### How can I build this image?

Just run `sudo ./build.sh`.

When running inside WSL, you may need to execute `sudo update-binfmts --enable` first.

For complete documentation, check the _pi-gen_ repository at https://github.com/RPi-Distro/pi-gen.
