# Boot process

## Live system early boot process

The ISO contains a compressed Live system filesystem image in uzip format. This filesystem image contains the filesystem used when running the ISO. During the Live system boot process, the image needs to get mounted and needs to get turned into a read-write filesystem so that one can make changes to the running system.

FreeBSD does not have a standard way to achieve this, so custom code has to be used. (The ISOs provided by the FreeBSD project do not use a compressed Live system filesystem image, and do not result in a read-write filesystem when being booted.)

This is a simplified description of the boot process. There may be additional aspects which still need to be documented.

1. The bootloader gets loaded
1. The bootloader loads the kernel modules that are required for the Live system boot process as specified in `overlays/boot/boot/loader.conf`. Note that the bootloader apparently is not smart enough to load the dependencies of kernel modules, so one needs to manually specify those as well. For example, `zfs.ko` up to FreeBSD 12 requires `opensolaris.ko` and from 13 onward requires `cryptodev.ko`
1. The bootloader loads the ramdisk image `ramdisk.ufs` as specified in `overlays/boot/boot/loader.conf` under `mfsroot_name`. The contents of the ramdisk image are specified in `overlays/ramdisk`
1. `init.sh` from the ramdisk image gets executed as requested by `overlays/boot/boot/loader.conf` under `init_script` and specified in `overlays/ramdisk/init.sh`. It constructs a r/w Live filesystem tree (e.g., by replicating the system image to swap-based memdisk) at `/livecd`
1. `/usr/local/bin/furybsd-init-helper` gets executed by `init.sh` in a chroot of the live filesystem, `/livecd`. It is defined in `overlays/uzip/furybsd-live-settings/files/usr/local/bin/furybsd-init-helper` and deals with loading Xorg configuration based on the detected devices on PCI, and with loading virtualization-related drivers
1. The `/livecd` chroot is exited
1. `init.sh` from the ramdisk image exits
1. `etc/rc` from the ramdisk image gets executed as specified in `overlays/ramdisk/etc/rc` (by what?). It tells the kernel to "reroot" (not "chroot") into the live filesystem, `/livecd` using `reboot -r`
1. From here on, the boot process is the regular FreeBSD boot process

### Troubleshooting the Live system early boot process

* __Hangs or reboots during replicating the system image to swap-based memdisk.__ The ISO is damaged. About one out of 10 builds of the ISO have this issue. Simply build a new ISO or wait for the next ISO to be available for download
* __"Cannot mount tmpfs on /dev/reroot: Operation not supported by device".__ Reason unkown. Are needed kernel modules missing?

### Seeing what the system is doing while the graphical boot screen is shown

While the graphical boot screen is being displayed you can press __Ctrl+T__ to see what it is doing at that moment in time. Press __Ctrl+T__ repeatedly to see what is going on over time.

### Boot in verbose mode

If you would like to observe the details of the boot process, you can start your computer in __verbose mode__. This allows you to inspect the Live system early boot process and to enter commands manually that would otherwise be executed automatically.

1. While the bootloader is running, keep the __Backspace__ key pressed until you see an `OK` prompt (alternatively, for a short time during boot, it says `Hit [Enter] to boot immediately, or any other key for command prompt.`. Press the __Esc__ key on your keyboard immediately when you see this)
1. Type `unset boot_mute`  and press the __Enter__ key. This disables the graphical splash screen and results in boot messages being shown
1. Type `boot -v` and press the __Enter__ key. This results in the system being booted in verbose mode

The computer should boot into a graphical desktop.

### Boot into verbose single-user mode

If your computer hangs during booting, you can boot into __verbose single-user mode__. This allows advanced users, administrators, and developers to inspect the Live system early boot process and to enter commands manually that would otherwise be executed automatically.

1. While the bootloader is running, keep the __Backspace__ key pressed until you see an `OK` prompt (alternatively, for a short time during boot, it says `Hit [Enter] to boot immediately, or any other key for command prompt.`. Press the __Esc__ key on your keyboard immediately when you see this)
1. Type `unset boot_mute`  and press the __Enter__ key. This disables the graphical splash screen and results in boot messages being shown
1. Type `boot -v -s` and press the __Enter__ key. This results in the system being booted in verbose single-user mode

The computer should boot into a text console rescue system in which parts of `init.sh` from the ramdisk image have run.

``` .. note::
    Single-user mode on the Live system currently is for developers of the Live system only. 
    
    If you boot the Live system into single-user mode, then you will be dropped into a shell in the ramdisk, and you are expected to manually enter the commands required for the Live system to continue booting which would otherwise be executed by the ramdisk automatically. Specifically, you need to enter everything below the line "Running in single-user mode" in the file overlays/ramdisk/init.sh (or variants thereof). If you just exit the shell without doing this, then the system will be unable to continue booting.
```

## Graphical desktop start process

1. The system is configured in `/etc/rc.conf` to start the `slim` login manager. This also results in Xorg being started
1. `slim` is configured in `/usr/local/etc/slim.conf` to start `start-hello` once the user has logged in, or if autologin has occured
1. The `/usr/local/bin/start-hello` shell script starts the various components of the helloSystem desktop

### Troubleshooting the graphical desktop start process

* Login manager (`slim`) says __Failed to execute login command__. Check the `/usr/local/bin/start-hello` shell script.

## Installed system boot process

The boot process is the regular FreeBSD boot process. Please refer to [The FreeBSD Booting Process](https://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/boot.html) for more information.

## Boot Mute

Setting `boot_mute="YES"` in `/boot/loader.conf` causes FreeBSD to show a boot splash screen instead of kernel messages during early boot. However, as soon as scripts from the ramdisk and init get executed, they tend to write output to the screen and manipulate it with `vidcontrol` and `conscontrol`, which results in the boot splash screen to disappear before the graphical desktop environment is started.

Since helloSystem targets a broad audience including non-technical users, the following behavior is intended:
* By default, show no textual boot messages
* Upon specific request by the user, show boot messages (for debugging, development, and system administration)
* Show a graphical splash screen during the entire boot process, all the way until the graphical desktop is started

To achieve this, helloSystem uses a combination of the following techniques:

* Read the `boot_mute` kernel environment variable and adjust the userland boot process accordingly
* Modify `/etc/rc` to run `conscontrol delete ttyv0` and redirect all of its output to `/dev/null` if `boot_mute` is set to `YES`
* Modify `/etc/rc.shutdown` to redirect all of its output to `/dev/null` if `boot_mute` is set to `YES`
* Replace the `/sbin/vidcontrol` command by a dummy that does nothing to prevent error messages related to setting the resolution of the text-mode console from ending the boot splash early
* Replace the `/etc/ttys` file with an empty file to not spawn login shells on the text-mode console
* Commenting out the line that ends in `/dev/console` in `/etc/syslog.conf` to prevent boot from being visually interrupted by `syslog` messages
* On the Live system, modify all scripts in the ramdisk to redirect all of their output to `/dev/null` if `boot_mute` is set to `YES`

``` .. note::
    Please note that if any errors are displayed on the screen during the boot process, the boot splash may still end early. In this case, the reason for the error message needs to be identified, and the message needs to be silenced.
```

To see boot messages, set `boot_mute="NO"` in `/boot/loader.conf` or at the bootloader prompt.
