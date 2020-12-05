# Boot process

## Live system

The ISO contains a Live system filesystem image in uzip format. This filesystem image contains the filesystem used when running the ISO. During the Live system boot process, the image needs to get mounted and needs to get turned into a read-write filesystem so that one can make changes to the running system.

FreeBSD does not have a standard way to achieve this, so custom code has to be used.

This is a simplified description of the boot process. There may be additional aspects which still need to be documented.

1. The bootloader gets loaded
1. The bootloader loads the kernel modules that are required for the Live system boot process as specified in `overlays/boot/boot/loader.conf`. Note that the bootloader apparently is not smart enough to load the dependencies of kernel modules, so one needs to manually specify those as well. For example, `zfs.ko` up to FreeBSD 12 requires `opensolaris.ko` and from 13 onward requires `cryptodev.ko`
1. The bootloader loads the ramdisk image `ramdisk.ufs` as specified in `overlays/boot/boot/loader.conf`. The contents of the ramdisk image are specified in `overlays/ramdisk`
1. `init.sh` from the ramdisk image gets executed as specified in `overlays/ramdisk/init.sh`. It constructs a r/w Live filesystem tree (e.g., by copying the system image to swap-based memdisk) at `/livecd`
1. `/usr/local/bin/furybsd-init-helper` gets executed by `init.sh` in a chroot of the live filesystem, `/livecd`. It is defined in `overlays/uzip/furybsd-live-settings/files/usr/local/bin/furybsd-init-helper` and deals with loading Xorg configuration based on the detected devices on PCI, and with loading virtualization-related drivers
1. The `/livecd` chroot is exited
1. `init.sh` from the ramdisk image exits
1. `etc/rc` from the ramdisk image gets executed as specified in `overlays/ramdisk/etc/rc` (by what?). It tells the kernel to "reroot" (not "chroot") into the live filesystem, `/livecd` using `reboot -r`

## Installed system

The boot process is the regular FreeBSD boot process.
