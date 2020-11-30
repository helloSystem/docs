# Building the Live ISO

helloSystem get assembled from upstream FreeBSD components, components in the FreeBSD packages system, and custom components from the helloSystem repositories.

helloSystem is not a derivative (fork) of FreeBSD (like e.g., GhostBSD), but strives to be "real FreeBSD" as far as possible. Hence, helloSystem does not build all source code, but relies on binaries provided by FreeBSD wherever possible.

helloSystem is distributed as an installable Live ISO file. This file gets built by the [hello Live ISO builder](https://github.com/helloSystem/ISO).

Continuous builds of the ISO get produced automatically on a continuous integration (CI) system for each git commit.

However, it is also possible to build the ISO locally, which is especially handy for testing and development.

## System requirements for building

* A FreeBSD or helloSystem installed on the computer. The FreeBSD version needs to match the FreeBSD version of the helloSystem ISO being built (e.g., `12.2-RELEASE`)
* 2 GHz dual core processor
* 4 GiB RAM (system memory)
* 50 GB of hard-drive space
* Either a CD-RW/DVD-RW drive or a USB port for writing the Live media
* A fast internet connection

## Building the Live ISO

```
git clone https://github.com/helloSystem/ISO
cd ISO
sudo ./build.sh hello
```

The resulting Live ISO will be located at `/usr/local/furybsd/iso/`.

## Writing Live Media to USB drive

```
sudo dd if=/usr/local/furybsd/iso/FuryBSD-12.1-XFCE.iso of=/dev/daX bs=4m status=progress
```

Replace `daX` with the respective device name.

``` .. warning::
    This will overwrite the entire contents of the selected device. Take extra caution when determining the device name.
    
    This operation cannot be undone.
```

For end users, there is the __Create Live Media__ application that can conveniently download and write Live Media with a graphical user interface.

## Burning Live Media to DVD

You can use the `cdrecord` command line tool to burn Live Media to DVD.

```
pkg install cdrtools
cdrecord /usr/local/furybsd/iso/<filename>.iso
```

## Customizing the Live ISO

helloSystem is built in a way that makes it trivially easy to apply your own changes to it.

### Different desktop environments

Simply replace `hello` with the name of one of the supported desktop environments, such as

* cinnamon
* gnome
* kde
* openbox
* xfce

While the resulting image will be built on the same infrastructure, those will not be helloSystem builds and are not supported by the project. Still, the community may find them useful.

### Customizing the set of packages

To add or remove packages, edit `settings/packages.<name>` and rebuild the image. Substitute `<name>` with `hello` or one of the desktop environments mentioned above.

### Customizing configuration

Configuration is applied using _transient packages_ that get generated on-the-fly from the contents of the `overlays/` directory.

* Overlays for the boot disk are stored in `overlays/boot`
* Overlays for the initial ramdisk are stored in `overlays/ramdisk`
* Overlays for the main filesystem are stored in `overlays/uzip/<overlay>/files/`. Note that to be included in a build, the overlay called `<overlay>` must be listed in `settings/overlays.<name>`. Substitute `<name>` with `hello` or one of the desktop environments mentioned above.

For example, a file that is supposed to appear in `/usr/local/bin/app` on the main filesystem could be stored in `overlays/uzip/hello/files/usr/local/bin/app`.

### Customizing the build script

If a file called `settings/script.<name>` exists, then it will be executed during the build. Substitute `<name>` with `hello` or one of the desktop environments mentioned above. For building helloSystem, `settings/script.hello` performs actions such as installing applications that are not coming from FreeBSD packages, setting the wallpaper, installing fonts that are not coming from FreeBSD, and so on.

All desktop-specific build steps should go into this file.
