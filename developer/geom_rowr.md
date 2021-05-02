# geom_rowr kernel module

The `geom_rowr` kernel module for FreeBSD makes a read-only device writable by combining it with a read-write device.

``` .. note::
    This kernel module is currently under development and is being tested for adoption in helloSystem.
```

## Use case

When creating a Live ISO, we want to use a read-only filesystem (that can reside on a medium that is physically read-only, such as a DVD) but make it appear to the system as if it was read-write (since some parts of the system may not work on a read-only system).

## Theory of operation

`geom_rowr` is a FreeBSD kernel module using the [GEOM Modular Disk Transformation Framework](https://docs.freebsd.org/en/books/handbook/geom.html). It allows you to take a read-only device (e.g. a DVD) and combine it with a read-write device (e.g., a swap-backed `md` memory disk) to get a new device that contains the data from the read-only device but is writable.

It is designed to work with any filesystem, including ZFS. It is compatible with `geom_uzip` so the read-only filesystem can be compressed with uzip.

The principle of operation is as follows:

* Reading a sector from the combined device reads it from the read-only device. Writing a sector writes it to the read-write device
* After a sector is written, future reads of that sector are satisfied from the read-write device as it contains the latest version of the sector's contents

As a result, immediately after creating the combined device, it appears to contain all the data from the read-only device. This means zero wait time for the user.

## Test

Execute the following commands as root:

```
# Prepare filesystem image
dd if=/dev/zero of=test.img bs=1M count=512
mdconfig -a -t vnode -f test.img -u 9
newfs /dev/md9
mount /dev/md9 /mnt
# Populate the filesystem
cp -R /boot/ /mnt
umount /mnt
mdconfig -d -u 9

# Load kernel module
kldload ./geom_rowr.ko
# prepare the read-only device md0 
mdconfig -a -t vnode -o readonly -f test.img -u 0
# prepare the read-write device md1
mdconfig -a -t swap -s 512M -u 1
# Make sure the geom(8) tool will find the .so
cp geom_rowr.so /lib/geom
# Create the new device that combines md0 and md1
geom rowr create rowr0 md0 md1
mount /dev/rowr0 /mnt

# See that the files are already there
ls /mnt
# make changes to the filesystem to see that it is read-write
mv /mnt/*.4th /mnt/lua; rm /mnt/pxeboot
```

## Use in the Live ISO boot process

This can be used for a Live ISO like this:

* On the ISO, there is a small `ramdisk.ufs` that contains the logic to mount the main filesystem using `geom_rowr`
* On the ISO, there is also the main filesystem `system.ufs` which is a UFS image compressed with `geom_uzip`
* At boot time, the code in the ramdisk creates a r/w swap-backed `md` device with the same size as the main r/o filesystem image, mounts it together with the main filesystem using `geom_rowr`, and chroots into the combined r/w filesystem. From there, the boot process continues as usual

## Caveats

### Device size

* The r/o image must have as much free space as you would like to have on the combined device. This can be achieved, e.g., like this: `makefs -b 20% -f 20% /usr/local/furybsd/cdroot/data/system.ufs /usr/local/furybsd/uzip` which will add an extra 20% of free space to the main filesystem image
* The free space is compressed very efficiently when the image is compressed with `geom_uzip`. This can be achieved, e.g., like this: `mkuzip -o /usr/local/furybsd/cdroot/data/system.uzip /usr/local/furybsd/cdroot/data/system.ufs`
* The uncompressed r/o image and the r/w device need to be the exact same size in bytes. Assuming variable `${x}` holds the size of the uncompressed r/o image in bytes, a matching r/w device with the same size in bytes can be created using `mdconfig -a -t swap -s ${x}b -u 2` (note the `b` suffix to the `-s` option). If this is not done correctly, we get the `geom: mediasize mismatch` error

You can have an [md(4)](https://www.freebsd.org/cgi/man.cgi?md%284%29) device be of size 3GB without it consuming 3GB of RAM.
This is valid for vnode-backed md devices, swap-backed md devices and malloc-backed when the `reserve` option to [mdconfig(8)](https://www.freebsd.org/cgi/man.cgi?mdconfig(8)) isn't used.

A swap-backed `md` device consumes close to zero memory when created and grows its memory use the more you write to it.

### Reroot

Because `reroot` cannot be made to work with `geom_rowr` at this time, we need to use `chroot`. 

When using `chroot`, some kernel modules that load firmware (e.g., for Intel WLAN drivers) fail to load the firmware if the places where kernel modules are located - `/boot/kernel` and `/boot/modules` - will look differently inside vs. outside the chroot.

This can be fixed.

Recommended way (to be tested):

Provided that `ramdisk.ufs` does not contain `/boot`, create a symlink on `ramdisk.ufs` from `/boot` to `/sysroot/boot`. The symlink can be made at image creation time or by a script that runs at runtime. This combined with the *default* `kern.module_path` should be enough to create a common view between the kernel and chrooted userland utilities. The places where kernel modules are located - `/boot/kernel` and `/boot/modules` - will look the same inside and outside of the chroot.

Alternative way (known to work):

```
mkdir -p /sysroot/sysroot/boot # Needed?
mount -t nullfs /sysroot/boot /sysroot/sysroot/boot # Needed?

echo "==> Set kernel module path for chroot"
sysctl kern.module_path=/sysroot/boot/kernel
```

### ZFS

With ZFS there is a problem unrelated to the `geom_rowr` code. When ZFS performs discovery of devices which are part of a zpool, the read-only device could be found before the combined rowr device which leads to inability to import the pool read-write.

(TODO: Insert tested workaround here)

## License

```
geom_rowr.ko, geom_rowr.so: Copyright (c) 2021, Jordan Gordeev
```

The author states that once the code reaches a certain level of maturity, it will be published under the license used by the FreeBSD project.
