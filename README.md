# UbuntuAutoinstall
Autoinstall Ubuntu Server 22.04 LTS "Jammy Jellyfish" - Release amd64 (20220421)


## Overview
Ubuntu Server 20.04+ comes with a new automated OS installation method called autoinstall. It is a replacement of the debian-installer (preseed). Starting with the 20.04 release a new install mechanism was introduced using "[cloud-init](https://cloudinit.readthedocs.io/en/latest/index.html)" and "[curtin](https://curtin.readthedocs.io/en/latest/index.html)" with the Ubuntu subiquity install program.

Autoinstallation lets you answer all those configuration questions ahead of time with an autoinstall config and lets the installation process run without any interaction.

This repository contains configuration files for on premise auto installation of Ubuntu server in fully automatic mode. To automatically install the server, you need data files with directives describing all the actions that the installer must perform.

### Automated Server Installs Config Files:

- **user-data** - this is the YAML file that will contain the autoinstall directives.
- **meta-data** and **vendor-data**[^1] - which will be an empty file in my case but would contain vendor specific information when launching on some cloud service.

[^1]:Both of this files used by cloud providers to pass along environment-specific data.

Additionally, the repository includes a bash script for managing the swap file and a Python SimpleHTTP server for distributing configuration files during installation process.

## Description

After the installation is completed, you will receive a pre-configured server in a working configuration.

During the installation process, the following steps are performed:

- Configure the apt settings to specify which repository to use during installation
- Set locale and timezone
- Installing and preconfiguration sshd server
- Server LVM file system is created (user-data described configuration for disk size 72GB[^2])
- Network configuration (DHCP)[^3]
- Update to the latest packages during installation
- Added a user with administrative privileges (in my config username: ```ubuntu``` with password ```ubuntu```.
- ssh public key into the authorized_keys are added for the user ```ubuntu```
- sudo configuration files is created for ```ubuntu``` user and users group ```root```

### The server file system will have the following partitions (example for disk size 72G)
```
NAME             FSTYPE      FSVER    SIZE    MOUNTPOINTS
sda                                           
├─sda1           vfat        FAT32         1G /boot/efi
├─sda2           ext4        1.0       208.3M /boot
└─sda3           LVM2_member LVM2 001         
  ├─vg0-lv--tmp  btrfs                   2.4G /tmp
  ├─vg0-lv--root btrfs                  50.7G /
  └─vg0-lv--home btrfs                   5.9G /home
```

[^2]:a separate file contains the configuration for a disk size 48G
[^3]:ens33 network adapter driver is used

## References

- [Ubuntu Automated Server Installs](https://ubuntu.com/server/docs/install/autoinstall)
- [Ubuntu Autoinstall Quick Start](https://ubuntu.com/server/docs/install/autoinstall-quickstart)
- [Ubuntu Automated Server Installs Config File Reference](https://ubuntu.com/server/docs/install/autoinstall-reference)
- [Cloud-init](https://cloudinit.readthedocs.io/en/latest/index.html)
- [Curtin](https://curtin.readthedocs.io/en/latest/topics/overview.html)


