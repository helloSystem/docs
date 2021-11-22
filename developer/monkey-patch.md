# Monkey Patching

Starting with helloSystem 0.7.0 it is possible to [monkey patch](https://en.wikipedia.org/wiki/Monkey_patch) the running Live ISO as early in the boot process as possible so that developers can make changes to all aspects of an existing Live ISO without having to re-create it and without having to write the ISO to a device each time a change is to be tested.

With that, it allows for a very rapid development-test cycle for Live ISOs.

``` .. note::
    This feature is currently under active development and its usage is still subject to change.
```

## Theory of operation

Since an ISO file is read-only by design, the monkey patch feature allows to insert code into the early boot process from another loacation, e.g., from a USB stick.

If the user tells the system to perform the monkey patching, the early boot scripts in helloSystem execute code provided by the user (outside of the ISO), then continues the normal boot process.

## Creating the monkey patch volume

![image](https://user-images.githubusercontent.com/2480569/141862072-250f4d58-b5a5-4857-9bd0-70651690796e.png)

* Format a USB stick with the FAT32 (`msdosfs`) file system
* The volume must have the name ("filesystem label") `MONKEYPATCH`
* There must be a `monkeypatch.sh` file that will be run by `#!/bin/sh`

## Booting a Live ISO applying the monkey patch on-the-fly

* Boot the ISO but interrupt the bootloader by pressing the Esc key
* At the boot prompt, enter: `set monkey_patch=YES`
* Optionally, use `unset BOOT_MUTE` so that you can see messages on the screen during boot
* Start the system by entering `boot`

The code inside the file `monkeypatch.sh` on the volume called `MONKEYPATCH` will be executed before `/sbin/init` on the Live ISO is started but after most areas of the ISO have been made writable by `/boot/init_script`.

## Example `monkeypatch.sh` file

```
# Write a file
echo "HELLO MONKEY" > /tmp/MONKEY_WAS_HERE

# Patch something on the ISO
sed -i '' -e 's|\&\& __wait 3|\&\& sync|g' /etc/rc.d/initgfx

# Show a message if the system is booted without `boot_mute`
echo "HELLO DEVELOPERS"

# Show a message to users in the boot process
# This should be done only in rare cases since it destroys
# the helloSystem zero-text boot experience
echo "HELLO MERE MORTALS" > /dev/console

# Override a file in the running system from the MONKEYPATCH volume
HERE="$(dirname "$(readlink -f "${0}")")"
cp ${HERE}/mount_md /usr/local/sbin/mount_md
chmod +x /usr/local/sbin/mount_md
```

* There must be a `monkeypatch.sh` file that will be run by `#!/bin/sh`

## Booting a Live ISO running a different `init_script`

If you would like to test changes to `/boot/init_script` on the ISO without having to re-create it and without having to write the ISO to a device, you can use the `monkey_patch_init_script` feature:

* Boot the ISO but interrupt the bootloader by pressing the Esc key
* At the boot prompt, enter: `set monkey_patch_init_script=YES`
* Optionally, use `unset BOOT_MUTE` so that you can see messages on the screen during boot
* Start the system by entering `boot`

The code inside the file `init_script` on the volume called `MONKEYPATCH` will be executed instead of `/boot/init_script` on the ISO.
