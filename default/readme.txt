DEFAULT INSTANCE CONFIGURATION

- Interactive mode for `storage` module
- No `swap` partition. The swap file is created automatically
  with a size equal to the amount of VM memory

PARTITION TABLE CREATED BY DEFAULT

NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda                         8:0    0   48G  0 disk
├─sda1                      8:1    0    1G  0 part /boot/efi
├─sda2                      8:2    0    2G  0 part /boot
└─sda3                      8:3    0 44.9G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 22.5G  0 lvm  /

Disk /dev/sda: 51.5GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start   End     Size    File system  Name  Flags
 1      1049kB  1128MB  1127MB  fat32              boot, esp
 2      1128MB  3276MB  2147MB  ext4
 3      3276MB  51.5GB  48.3GB

LVM VOLUMES

Note: Disk is not used effectively during automatic partitioning.
      Primary volume uses only 50% of free disk space.

Disk /dev/mapper/ubuntu--vg-ubuntu--lv: 24.1GB
Partition Table: loop
Number  Start  End     Size    File system  Flags
 0      0.00B  24.1GB  24.1GB  ext4

SWAP FILE (FOR VM WITH 3GB RAM)

Name:   /swap.img
Type:   file
Size:   2.9G

               total        used        free      shared  buff/cache   available
Mem:            2946         246        2443           0         256        2538
Swap:           2946           0        2946


PRE-INSTALLED PACKAGES

 git
 jq
 less
 nano
 netcat
 open-vm-tools
 zsh
 parted
