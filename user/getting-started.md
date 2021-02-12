# Getting started

## Status

hello is currently being developed. It is not yet available for general use, but advanced users can try out continuous builds of pre-alpha ISO images that can be booted from DVD or USB storage media.

## System requirements

* 2 GHz dual core Intel/ARM 64-bit processor
* 4 GiB RAM (system memory for physical and viritualized installs)
* VGA capable of 1024x768 screen resolution
* Either a CD/DVD drive or a USB port for booting the installer media

In the future, there may also be builds for other processor architectures. We would like to bring down the RAM requirement considerably.

Please refer to [FreeBSD Hardware Compatibility](https://www.freebsd.org/doc/en_US.ISO8859-1/books/faq/hardware.html) for more information on individual components.

### Tested hardware

hello is known to boot to a graphical desktop on the following machines. Auxiliary functionality such as wireless networking, sound over HDMI, sleep, graphics acceleration, etc. has not yet been tested systematically.

* Acer Revo RL85
* Dell Inc. OptiPlex 780

### Tested virtualization environments

* VirtualBox host (on FreeBSD and on macOS), known to work in BIOS and EFI mode

* VMware host (on Windows), possibly only working in BIOS mode?

* Qemu VM, works in both BIOS and EFI modes

You can boot and install hello in a Qemu VM. First create a disk image for it with fallocate:
```
$ pwd
/home/user
$ mkdir -p .qemu/hello
$ fallocate -l $(( 24*1024*1024*1024 )) .qemu/hello/hello.img
```
This creates a 24 GiB hello.img file where you'll install the system.

To boot the hello ISO image, use the following qemu-system-x86_64 command:
```
qemu-system-x86_64 -machine type=q35,accel=kvm \
-enable-kvm -cpu host -smp 2 -m 4096 \
-device virtio-net,netdev=vmnic -netdev user,id=vmnic,hostfwd=tcp::5222-:22 \
-vga std -soundhw hda -no-quit \
-drive format=raw,file=${HOME}/.qemu/hello/hello.img \
-drive format=raw,file=${HOME}/Downloads/hello-0.4.0_0D26-FreeBSD-12.1-amd64.iso \
-boot menu=on
```
When the Qemu VM starts, press esc and select 2 to boot the iso.

After you've installed hello on the disk image, you can remove the last two options from the above command.

The hostfwd= option creates a port forward from your host port 5222 to the Qemu VM port 22.

Unfortunately the qemu-system-x86_64 USB tablet options don't work with hello so you'll need to press Ctrl+Alt+g to release the mouse pointer from the Qemu VM window.

If you want to make Qemu VM full screen, press Ctrl+Alt+f.

To boot/install hello in UEFI mode, first install [OVMF Open Virtual Machine Firmware](https://github.com/tianocore/tianocore.github.io/wiki/OVMF) on your host side. The package name for Fedora 32 is edk2-ovmf.

Then add these two qemu-system-x86_64 options for the Qemu VM start:
```
-bios /usr/share/edk2/ovmf/OVMF_CODE.fd \
-smbios type=0,vendor=0vendor,version=0version,date=0date,release=0.0,uefi=on \
```

Please note:

* The VM needs to be 64-bit
* The VM needs at least 4 GB of RAM which is higher than the VirtualBox default
* The boot process takes longer than you might expect; boot `-v` to see the details

Please report back about the results on your virtualization environment.

## Downloading

Pre-alpha ISO images are available for download [here](https://github.com/helloSystem/ISO/releases/).

```eval_rst
important:: Images get built automatically whenever source code is committed. Not every build is tested.
```
