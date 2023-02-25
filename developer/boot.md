# Boot process

## Speeding up the boot process

As a desktop-centric system, helloSystem should bring up a graphical desktop as soon as possible, and delay starting up other services such as the network beyond that point. Unfortunately, in the FreeBSD default configuration this is the other way around, and the graphical desktop will only start after the network has been configured, the time has been set using NTP, etc.

While it would be possible to change the order of the scripts in {file}`/etc/rc.d` and {file}`/usr/local/etc/rc.d`, those changes might get overwritten with subsequent FreeBSD or package updates. Hence, we should never edit startup scripts provided by FreeBSD or packages.

Instead, we can disable the services in question so that they don't get started as part of the normal FreeBSD boot sequence, and start them later in the boot process (after the graphical session has been started) using a custom start script.

:::{note}
The following instructions are DANGEROUS and can potentially lead to a system that cannot boot into a graphical desktop if things go wrong. This is currently only for developers and experienced users who know how to handle such situations. Future versions of helloSystem may come with this already set up.
:::

To do this, create a Boot Environment that you can roll back to in case things go wrong.

In {file}`/etc/rc.conf`, set

```text
defaultroute_carrier_delay="0"
defaultroute_delay="0"
background_dhclient="YES"
```

Then create the following {file}`/usr/local/etc/rc.d/late-start` script:

```sh
#!/bin/sh

# PROVIDE: late-start
# REQUIRE: slim

PATH=$PATH:/usr/sbin
export PATH

. /etc/rc.subr

name="late"
start_cmd="${name}_start"

extra_commands="disable_early_services"
disable_early_services_cmd="${name}_disable_early_services"

# NOTE: devd needs to stay enabled in early boot
# so that we have a working mouse pointer as soon as Xorg is started

SERVICES="setup-mouse webcamd vboxservice dsbdriverd netif routing defaultroute avahi-daemon clear-tmp cupsd ntpdate smartd sshd"

late_start()
{
    service devd restart # For networking; invokes dhcpd
    for SERVICE in $SERVICES ; do
        service "$SERVICE" onestart
    done
}

late_disable_early_services()
{
    for SERVICE in $SERVICES ; do
        service "$SERVICE" disable
    done
}

load_rc_config $name
run_rc_command "$1"
```

Disable the services in question with

```console
$ sudo chmod +x /usr/local/etc/rc.d/late-start
$ sudo service late-start disable_early_services
```

Check which services are still enabled, should now be greatly reduced:

```console
$ grep -r 'enable="YES"' /etc/rc.conf*
/etc/rc.conf:clear_tmp_enable="YES"
/etc/rc.conf:dbus_enable="YES"
/etc/rc.conf:initgfx_enable="YES"
/etc/rc.conf:load_acpi_enable="YES"
/etc/rc.conf:slim_enable="YES"
/etc/rc.conf:zfs_enable="YES"
```

Reboot. The graphical desktop (including a usable mouse pointer) should appear ~10 seconds faster, but the network will start to work only after ~10 seconds.

:::{note}
This starts services like sshd; you need to edit the {file}`/usr/local/etc/rc.d/late-start` script to only start the services you would like to be started.
:::

## Debugging the Live system boot process

The following has been tested on experimental helloSystem 0.8.0 builds.

Press the Backspace key on your keyboard during early boot until you see the `OK` prompt.

![bootloader](https://user-images.githubusercontent.com/2480569/202910570-9bcc21c5-d9f4-4c3f-b8c0-b07b7e36f35e.png)

Enter

```console
OK boot -s
```

to boot in single user mode. The system will boot to the first stage Live system prompt:

![livefirstsingleprompt](https://user-images.githubusercontent.com/2480569/202910574-22c0e284-8717-4ae0-9489-68cc23995e1d.png)

At this point, the Live system has not been made writable yet.
Enter {command}`exit` to contine. The system will boot to the second stage Live system prompt:

![livesecondsingleprompt](https://user-images.githubusercontent.com/2480569/202910576-e4253133-8544-4566-8b8e-8c0895f63edd.png)

At this point, the system has been made partly writable by the `init_script`. To see the messages, you can press the {kbd}`ScrLk` key on your keyboard and then use the arrow up and arrow down keys on your keyboard. Then press the {kbd}`ScrLk` key again.

Hit the {kbd}`Enter` key on your keyboard.

Here you can make changes to files like {file}`/usr/local/bin/start-hello`. 

For example, you can

```console
$ mv /usr/local/bin/start-hello /usr/local/bin/start-hello.original
$ ln -sf /usr/local/bin/xterm /usr/local/bin/start-hello
```

Then enter {command}`exit` to contine. The system will boot into the graphical desktop.

If you have made the above changes, you can run

```console
$ sh -x /usr/local/bin/start-hello.original
```

to watch {file}`start-hello.original` run in a graphical terminal.

![image](https://user-images.githubusercontent.com/2480569/202913068-5399a4fa-cefc-4ffc-ba24-9b752d6a4cff.png)

Here you can see what goes wrong, if anything... and then you can create, e.g., a replacement `start-hello` script that gets loaded with Monkey Patching.

## Live system early boot process

:::{note}
This section describes helloSystem boot process up to 0.6.0. Starting with version 0.7.0, helloSystem will use a completely different live system boot process. This page needs to be updated accordingly.
:::

The ISO contains a compressed Live system filesystem image in uzip format. This filesystem image contains the filesystem used when running the ISO. During the Live system boot process, the image needs to get mounted and needs to get turned into a read-write filesystem so that one can make changes to the running system.

FreeBSD does not have a standard way to achieve this, so custom code has to be used. (The ISOs provided by the FreeBSD project do not use a compressed Live system filesystem image, and do not result in a read-write filesystem when being booted.)

This is a simplified description of the boot process. There may be additional aspects which still need to be documented.

1. The bootloader gets loaded
2. The bootloader loads the kernel modules that are required for the Live system boot process as specified in {file}`overlays/boot/boot/loader.conf`. Note that the bootloader apparently is not smart enough to load the dependencies of kernel modules, so one needs to manually specify those as well. For example, `zfs.ko` up to FreeBSD 12 requires `opensolaris.ko` and from 13 onward requires `cryptodev.ko`
3. The bootloader loads the ramdisk image `ramdisk.ufs` as specified in {file}`overlays/boot/boot/loader.conf` under `mfsroot_name`. The contents of the ramdisk image are specified in `overlays/ramdisk`
4. `init.sh` from the ramdisk image gets executed as requested by {file}`overlays/boot/boot/loader.conf` under `init_script` and specified in {file}`overlays/ramdisk/init.sh`. It constructs a r/w Live filesystem tree (e.g., by replicating the system image to swap-based memdisk) at `/livecd`
5. {file}`/usr/local/bin/furybsd-init-helper` gets executed by `init.sh` in a chroot of the live filesystem, `/livecd`. It is defined in {file}`overlays/uzip/furybsd-live-settings/files/usr/local/bin/furybsd-init-helper` and deals with loading Xorg configuration based on the detected devices on PCI, and with loading virtualization-related drivers
6. The `/livecd` chroot is exited
7. `init.sh` from the ramdisk image exits
8. `etc/rc` from the ramdisk image gets executed as specified in {file}`overlays/ramdisk/etc/rc` (by what?). It tells the kernel to "reroot" (not "chroot") into the live filesystem, `/livecd` using {command}`reboot -r`
9.  From here on, the boot process is the regular FreeBSD boot process with the following particularities:
10. {file}`/etc/rc.d/initgfx` detects the GPU and loads the appropriate drivers
11. {file}`/usr/local/etc/rc.d/localize` runs {file}`/usr/local/sbin/localize` which tries to determine the language of the keyboard, and by proxy, of the system. This currently supports the official Raspberry Pi keyboard and Apple computers which store the keyboard and system language in the `prev-lang:kbd` EFI variable
13. The `slim` session manager (login window) is started; when the user is logged in, it starts the script {file}`/usr/local/bin/start-hello` which starts the desktop session and sets the keyboard and system language based on the information provided by `localize` in an earlier step

### Troubleshooting the Live system early boot process

* __Hangs or reboots during replicating the system image to swap-based memdisk.__ The ISO is damaged. About one out of 10 builds of the ISO have this issue. Simply build a new ISO or wait for the next ISO to be available for download
* __"Cannot mount tmpfs on /dev/reroot: Operation not supported by device".__ Reason unknown. Are needed kernel modules missing?

### Seeing what the system is doing while the graphical boot screen is shown

While the graphical boot screen is being displayed you can press __Ctrl+T__ to see what it is doing at that moment in time.  By keeping __Ctrl+T__ __pressed down__ you can see what is going on over time. By then pressing __ScrLk__, you can use __PgUp__ and __PgDn__ to scroll around.

The following information will be printed to the screen for the most relevant process based on recency and CPU usage (as decided by `proc_compare()`): 

* `load:` and the 1 minute load average of the system
* `cmd:` and process name of the most relevant process
* Process ID (PID) of that process
* State of that process in  `[]`. FreeBSD specific wait states are explained in https://wiki.freebsd.org/WaitChannels
* Real (r), User (u), and System (s) times ([Source](https://stackoverflow.com/a/556411))
  * Real is wall clock time - time from start to finish of the call. This is all elapsed time including time slices used by other processes and time the process spends blocked (for example if it is waiting for I/O to complete)
  * User is the amount of CPU time spent in user-mode code (outside the kernel) _within_ the process. This is only actual CPU time used in executing the process. Other processes and time the process spends blocked do not count towards this figure
  * Sys is the amount of CPU time spent _in the kernel for the process_. This means executing CPU time spent in system calls within the kernel, as opposed to library code, which is still running in user-space
* CPU usage in percent 
* Resident set size (RSS), the amount of memory occupied in RAM by the most relevant process

Example: `load: 0.62  cmd: sleep 1739 [nanslp] 2.97r 0.00u 0.00s 0% 2168k`

### Boot in verbose mode

If you would like to observe the details of the boot process, you can start your computer in __verbose mode__. This allows you to inspect the Live system early boot process and to enter commands manually that would otherwise be executed automatically.

Since helloSystem 0.8.1: To boot in verbose mode, press the "v" key as soon as the screen becomes grey.

Before helloSystem 0.8.1:
1. While the bootloader is running, keep the {kbd}`Backspace` key pressed until you see an `OK` prompt (alternatively, for a short time during boot, it says `Hit [Enter] to boot immediately, or any other key for command prompt.`. Press the {kbd}`Esc` key on your keyboard immediately when you see this)
2. Type `unset boot_mute`  and press the {kbd}`Enter` key. This disables the graphical splash screen and results in boot messages being shown
3. Type `boot -v` and press the {kbd}`Enter` key. This results in the system being booted in verbose mode

The computer should boot into a graphical desktop.

### Boot into verbose single-user mode

If your computer hangs during booting, you can boot into __verbose single-user mode__. This allows advanced users, administrators, and developers to inspect the Live system early boot process and to enter commands manually that would otherwise be executed automatically.

Since helloSystem 0.8.1: To boot in verbose single-user mode, press the "s" key as soon as the screen becomes grey.

Before helloSystem 0.8.1:
1. While the bootloader is running, keep the {kbd}`Backspace` key pressed until you see an `OK` prompt (alternatively, for a short time during boot, it says `Hit [Enter] to boot immediately, or any other key for command prompt.`. Press the {kbd}`Esc` key on your keyboard immediately when you see this)
1. Type `unset boot_mute`  and press the {kbd}`Enter` key. This disables the graphical splash screen and results in boot messages being shown
1. Type `boot -v -s` and press the {kbd}`Enter` key. This results in the system being booted in verbose single-user mode

The computer should boot into a text console rescue system in which parts of `init.sh` from the ramdisk image have run.

:::{note}
Single-user mode on the Live system currently is for developers of the Live system only. 

If you boot the Live system into single-user mode, then you will be dropped into a shell in the ramdisk, and you are expected to manually enter the commands required for the Live system to continue booting which would otherwise be executed by the ramdisk automatically. Specifically, you need to enter everything below the line "Running in single-user mode" in the file overlays/ramdisk/init.sh (or variants thereof). If you just exit the shell without doing this, then the system will be unable to continue booting.
:::

## Graphical desktop start process

1. The system is configured in {file}`/etc/rc.conf` to start the `slim` login manager. This also results in Xorg being started
2. `slim` is configured in {file}`/usr/local/etc/slim.conf` to start `start-hello` once the user has logged in, or if autologin has occurred
3. The {file}`/usr/local/bin/start-hello` shell script starts the various components of the helloSystem desktop

### Troubleshooting the graphical desktop start process

* Login manager (`slim`) says __Failed to execute login command__. Check the {file}`/usr/local/bin/start-hello` shell script.

## Installed system boot process

The boot process is the regular FreeBSD boot process. Please refer to [The FreeBSD Booting Process](https://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/boot.html) for more information.

## Boot Mute

Setting `boot_mute="YES"` in {file}`/boot/loader.conf` causes FreeBSD to show a boot splash screen instead of kernel messages during early boot. However, as soon as scripts from the ramdisk and init get executed, they tend to write output to the screen and manipulate it with `vidcontrol` and `conscontrol`, which results in the boot splash screen to disappear before the graphical desktop environment is started.

Since helloSystem targets a broad audience including non-technical users, the following behavior is intended:
* By default, show no textual boot messages
* Upon specific request by the user, show boot messages (for debugging, development, and system administration)
* Show a graphical splash screen during the entire boot process, all the way until the graphical desktop is started

To achieve this, helloSystem uses a combination of the following techniques:

* Read the `boot_mute` kernel environment variable and adjust the userland boot process accordingly
* Modify {file}`/etc/rc` to run `conscontrol delete ttyv0` and redirect all of its output to `/dev/null` if `boot_mute` is set to `YES`
* Modify {file}`/etc/rc.shutdown` to redirect all of its output to `/dev/null` if `boot_mute` is set to `YES`
* Replace the `/sbin/vidcontrol` command by a dummy that does nothing to prevent error messages related to setting the resolution of the text-mode console from ending the boot splash early
* Replace the {file}`/etc/ttys` file with an empty file to not spawn login shells on the text-mode console
* Commenting out the line that ends in `/dev/console` in {file}`/etc/syslog.conf` to prevent boot from being visually interrupted by `syslog` messages
* On the Live system, modify all scripts in the ramdisk to redirect all of their output to `/dev/null` if `boot_mute` is set to `YES`

:::{note}
Please note that if any errors are displayed on the screen during the boot process, the boot splash may still end early. In this case, the reason for the error message needs to be identified, and the message needs to be silenced.
:::

To see boot messages, set `boot_mute="NO"` in {file}`/boot/loader.conf` or at the bootloader prompt.


## Modifying bootloader scripts

The bootloader executes lua scripts as part of the boot process. This is not documented extensively in the FreeBSD documentation.

To work on the lua scripts, it is useful to
* Use VirtualBox
* Install helloSystem to a virtual hard disk
* In the installed system, edit `/boot/loader.conf` to contain `beastie_disable=NO` and increase the timeout

Possibly there is also a way to use a lua interpreter on the booted system to work on and debug the lua scripts, but this is currently unknown. The following does not seem to work:

```
% lua54 ./loader.lua 
lua54: ./core.lua:447: attempt to index a nil value (global 'loader')
stack traceback:
        ./core.lua:447: in field 'isSystem386'
        ./core.lua:56: in local 'recordDefaults'
        ./core.lua:525: in main chunk
        [C]: in function 'require'
        ./cli.lua:31: in main chunk
        [C]: in function 'require'
        ./loader.lua:36: in main chunk
        [C]: in ?
```

The `/boot` directory also contains files referring to 4th, those are all unused, misleading, and can be removed. Besides files with `4th` in their name this also includes files ending in `.rc`.

```
mount -uw /
cd /boot
find . -name '*4th*' -exec rm {} \;
rm *.rc
```

Removing the misleading files makes it easier to see which code actually gets executed. All the scripting is essentially happening in `/boot/lua`.

One can then edit the scripts in `/boot/lua`, and boot the virtual machine quickly into single user mode, make edits, and repeat.

It seems that `/boot/lua/loader.lua` is the entry point that is hardcoded into the bootloader.

So if we would like to run a "hello world", we would need to place it at that path.

`/boot/lua/loader.lua` includes other lua files, e.g., `local core = require("core")`.

`/boot/lua/core.lua` contains the following function:

```
function core.isMenuSkipped()
        return string.lower(loader.getenv("beastie_disable") or "") == "yes"
end
```

`/boot/lua/loader.lua` uses this function to display the boot menu if `beastie_disable` is not set:

```
if not core.isMenuSkipped() then
        require("menu").run()
else
        -- Load kernel/modules before we go
        config.loadelf()
end
```

Directly above this, there is

```
try_include("local")
```

which seems to suggest that we can hook in our own code there by creating a new file `/boot/lua/local.lua` with our custom code:

https://github.com/helloSystem/ISO/blob/experimental/overlays/boot/boot/lua/local.lua

* https://man.freebsd.org/cgi/man.cgi?query=core.lua documents the functions in `core.lua`
* https://man.freebsd.org/cgi/man.cgi?query=menu.lua&sektion=8 documents `menu.lua`, including an example for how to replace the default boot menu with a simple boot menu, and en example for how to add another option to the default FreeBSD welcome menu

This allows us to
* Load the kernel and modules without showing text on screen
* Boot in verbose mode if the `V` key is pressed
* Boot in single user mode if the `S` key is pressed
* Show the FreeBSD bootloader menu if backspace is pressed
* Adjust colors for verbose and single user boot

The lua environment in the FreeBSD bootloader has some functions starting with `loader.` that seem to be undocumented, but we can list them by looking at the source code:

* `loader.command()`
* `loader.perform()`
* `loader.command_error()`
* `loader.interpret()`
* `loader.parse()`
* `loader.getchar()`
* `loader.ischar()`
* `loader.gets()`
* `loader.time()`
* `loader.delay()`
* `loader.getenv()`
* `loader.setenv()`
* `loader.unsetenv()`
* `loader.printc()`
* `loader.openfile()`
* `loader.closefile()`
* `loader.readfile()`
* `loader.writefile()`
* `loader.term_putimage()`
* `loader.fb_putimage()`
* `loader.fb_setpixel()`
* `loader.fb_line()`
* `loader.fb_bezier()`
* `loader.fb_drawrect()`
* `loader.term_drawrect()`

This list was generated on a system on which the FreeBSD source code is installed in `/usr/src` using the following command:

```
grep -r '^lua_' /usr/src/stand/liblua/*.c | cut -d ":" -f 2 | sed -e 's|lua_|loader.|g' | sed -e 's|loader.State \*L||g' | sed -e 's|^|* \`|g' | sed -e 's|)|)\`|g'
```
