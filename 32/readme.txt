INSTANCE CONFIGURATION

- 32GB storage/disk size
- No `swap` partition. A swap file is created with an initial
  size of 256MB and a maximum size of 2GB

PARTITION TABLE DETAILS

Disk /dev/sda: 34.4GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start   End     Size    File system  Name  Flags
 1      1049kB  1128MB  1127MB  fat32              boot, esp
 2      1128MB  1665MB  537MB   ext4
 3      1665MB  34.4GB  32.7GB

NAME             MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda                8:0    0   32G  0 disk
├─sda1             8:1    0    1G  0 part /boot/efi
├─sda2             8:2    0  512M  0 part /boot
└─sda3             8:3    0 30.4G  0 part
  ├─vg0-lv--tmp  253:0    0    3G  0 lvm  /tmp
  ├─vg0-lv--root 253:1    0   17G  0 lvm  /
  └─vg0-lv--home 253:2    0 10.4G  0 lvm  /home
sr0               11:0    1 1024M  0 rom

LVM VOLUMES

Disk vg0-lv--tmp:  3221MB
Disk vg0-lv--root: 18.3GB
Disk vg0-lv--home: 11.2GB

Number  Start  End     Size    File system  Flags
 0      0.00B  3221MB  3221MB  btrfs
 1      0.00B  18.3GB  18.3GB  btrfs
 2      0.00B  11.2GB  11.2GB  btrfs

SWAP

Name:   /swap.img
Type:   file
Size:   256M


PRE-INSTALLED PACKAGES

 git
 jq
 less
 nano
 open-vm-tools
 parted
 psmisc
 zip
 zsh
