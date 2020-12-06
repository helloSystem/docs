# Boot process

## Live system early boot process

The ISO contains a compressed Live system filesystem image in uzip format. This filesystem image contains the filesystem used when running the ISO. During the Live system boot process, the image needs to get mounted and needs to get turned into a read-write filesystem so that one can make changes to the running system.

FreeBSD does not have a standard way to achieve this, so custom code has to be used. (The ISOs provided by the FreeBSD project do not use a compressed Live system filesystem image, and do not result in a read-write filesystem when being booted.)

This is a simplified description of the boot process. There may be additional aspects which still need to be documented.

1. The bootloader gets loaded
1. The bootloader loads the kernel modules that are required for the Live system boot process as specified in `overlays/boot/boot/loader.conf`. Note that the bootloader apparently is not smart enough to load the dependencies of kernel modules, so one needs to manually specify those as well. For example, `zfs.ko` up to FreeBSD 12 requires `opensolaris.ko` and from 13 onward requires `cryptodev.ko`
1. The bootloader loads the ramdisk image `ramdisk.ufs` as specified in `overlays/boot/boot/loader.conf`. The contents of the ramdisk image are specified in `overlays/ramdisk`
1. `init.sh` from the ramdisk image gets executed as specified in `overlays/ramdisk/init.sh`. It constructs a r/w Live filesystem tree (e.g., by replicating the system image to swap-based memdisk) at `/livecd`
1. `/usr/local/bin/furybsd-init-helper` gets executed by `init.sh` in a chroot of the live filesystem, `/livecd`. It is defined in `overlays/uzip/furybsd-live-settings/files/usr/local/bin/furybsd-init-helper` and deals with loading Xorg configuration based on the detected devices on PCI, and with loading virtualization-related drivers
1. The `/livecd` chroot is exited
1. `init.sh` from the ramdisk image exits
1. `etc/rc` from the ramdisk image gets executed as specified in `overlays/ramdisk/etc/rc` (by what?). It tells the kernel to "reroot" (not "chroot") into the live filesystem, `/livecd` using `reboot -r`
1 From here on, the boot process is the regular FreeBSD boot process

### Troubleshooting the Live system early boot process

* __Hangs or reboots during replicating the system image to swap-based memdisk.__ The ISO is damaged. About one out of 10 builds of the ISO have this issue. Simply build a new ISO or wait for the next ISO to be available for download
* __"Cannot mount tmpfs on /dev/reroot: Operation not supported by device".__ Reason unkown. Are needed kernel modules missing?

### Boot in verbose mode

If you would like to observe the details of the boot process, you can start your computer in __verbose mode__. This allows you to inspect the Live system early boot process and to enter commands manually that would otherwise be executed automatically.

1. For a short time during boot, it says `Hit [Enter] to boot immediately, or any other key for command prompt.`. Press the __Esc__ key on your keyboard immediately when you see this
1. Type `unset boot_mute`  and press the __Enter__ key. This disables the graphical splash screen
1. Type `set console=text`  and press the __Enter__ key. This results in boot messages being shown on screen
1. Type `boot -v` and press the __Enter__ key. This results in the system being booted in verbose mode

The computer should boot into a graphical desktop.

### Boot into verbose single-user mode

If your computer hangs during booting, you can boot into __verbose single-user mode__. This allows advanced users, administrators, and developers to inspect the Live system early boot process and to enter commands manually that would otherwise be executed automatically.

1. For a short time during boot, it says `Hit [Enter] to boot immediately, or any other key for command prompt.`. Press the __Esc__ key on your keyboard immediately when you see this
1. Type `unset boot_mute`  and press the __Enter__ key. This disables the graphical splash screen
1. Type `set console=text`  and press the __Enter__ key. This results in boot messages being shown on screen
1. Type `boot -v -s` and press the __Enter__ key. This results in the system being booted in verbose single-user mode

The computer should boot into a text console rescue system in which parts of `init.sh` from the ramdisk image have run.

## Installed system boot process

The boot process is the regular FreeBSD boot process.

## Graphical desktop start process

1. The system is configured in `/etc/rc.conf` to start the `slim` login manager. This also results in Xorg being started
1. `slim` is configured in `/usr/local/etc/slim.conf` to start `start-hello` once the user has logged in, or if autologin has occured
1. The `/usr/local/bin/start-hello` shell script starts the various components of the helloSystem desktop

### Troubleshooting the graphical desktop start process

* Login manager (`slim`) says __Failed to execute login command__. Check the `/usr/local/bin/start-hello` shell script.
