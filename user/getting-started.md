# Getting started

## Status

hello is currently being developed. It is not yet available for general use, but advanced users can try out continuous builds of pre-alpha ISO images that can be booted from DVD or USB storage media.

## System requirements

* 2 GHz dual core Intel/ARM 64-bit processor
* 4 GiB RAM (system memory for physical and viritualized installs)
* VGA capable of 1024x768 screen resolution
* Either a CD/DVD drive or a USB port for booting the installer media
* On non-Macintosh hardware, a [Raspberry Pi keyboard](https://static.raspberrypi.org/files/product-briefs/210108_Product_Brief_Keyboard_and_Mouse.pdf) is recommended as it allows the keyboard and system language to be detected automatically if it is attached while the system is starting up. On Macintosh hardware, the `prev-lang:kbd` EFI variable is usually set and is used to detect the keyboard and system language. Note that the key left to the space bar is used as the Command key (Alt key on PC keyboards, Apple key on Apple keyboards).

In the future, there may also be builds for other processor architectures. We would like to bring down the RAM requirement considerably.

Please refer to [FreeBSD Hardware Compatibility](https://www.freebsd.org/doc/en_US.ISO8859-1/books/faq/hardware.html) for more information on individual components.

### Tested hardware

hello is known to boot to a graphical desktop on the following machines. Auxiliary functionality such as wireless networking, sound over HDMI, sleep, graphics acceleration, etc. has not yet been tested systematically.

helloSystem developers currently have access to the following hardware:

* Acer Revo RL85
* Dell Inc. OptiPlex 780

Please contact us if you would like to sponsor the project with a hardware donation. We are especially looking for Apple and Lenovo devices from the previous generations that should be available second-hand inexpensively.

To see Hardware Probes of systems running helloSystem, please see the [helloSystem Hardware Database](http://bsd-hardware.info/?d=helloSystem&view=computers) provided by bsd-hardware.info. It is reasonable to assume that every system listed there can at least successfully boot helloSystem. Auxiliary functionality such as wireless networking, sound over HDMI, sleep, graphics acceleration, etc. may or may not be working.

### Networking hardware

Not all networking devices may be supported by FreeBSD yet. In those cases, you may want to consider using a USB based networking devices. helloSystem developers currently have access to the following USB based networking devices which are known to work:

* [USB 802.11n WLAN Adapters based on `ID 0bda:8176 Realtek Semiconductor Corp. RTL8188CUS`](https://vermaden.wordpress.com/2020/10/30/realtek-usb-wifi-review/)
* [USB Wired Ethernet Adapters based on `ID 0b95:772b ASIX Electronics Corp. AX88772B`](https://www.freebsd.org/cgi/man.cgi?query=axe)

### Virtualization environments

``` .. note::
    We recommend running helloSystem on real hardware ("bare metal") if possible. This should give you the best possible performance and hardware support.
```

Users have reported success in running helloSystem in the following virtualization environments:

* VirtualBox host (on FreeBSD and on macOS), known to work in BIOS and EFI mode

* VMware host (on Windows), possibly only working in BIOS mode?

* QEMU host (on Linux), works in both BIOS and EFI modes (see below). Note that for acceptable performance, QEMU needs KVM which is currently not available on FreeBSD hosts yet 

* Parallels host, reported to work in EFI mode (see below)

* Proxmox VE

Please note:

* The VM needs to be __64-bit__
* The VM needs __at least 4 GB of RAM__
* The VM needs __at least 2 CPU cores__
* The boot process takes longer than you might expect; boot in verbose mode to see the details
* For best results set **EFI/UEFI** boot mode (not BIOS)

Please report back about the results on your virtualization environment.

#### QEMU

Create an 8 GiB (or larger) `hello.img` image file on which you can install the system:

```
$ pwd
/home/user
$ mkdir -p .qemu/hello
$ fallocate -l $(( 8*1024*1024*1024 )) .qemu/hello/hello.img
```

Then, boot helloSystem:

```
qemu-system-x86_64 -machine type=q35,accel=kvm \
-enable-kvm -cpu host -smp 2 -m 4096 \
-device virtio-net,netdev=vmnic -netdev user,id=vmnic,hostfwd=tcp::5222-:22 \
-vga std -soundhw hda -no-quit \
-drive format=raw,file=${HOME}/.qemu/hello/hello.img \
-drive format=raw,file=${HOME}/Downloads/hello-0.4.0_0D26-FreeBSD-12.1-amd64.iso \
-boot menu=on
```

When QEMU starts, press `esc` and select `2` to boot the ISO.

Use the __Install FreeBSD__ utility to install helloSystem do the disk image.

Then restart QEMU, you now remove the last two options from the above command.

Notes

* The `hostfwd=` option creates a port forward from your host port `5222` to the Qemu VM port `22`.
* Unfortunately the qemu-system-x86_64 USB tablet options do not work; you will need to press Ctrl+Alt+g to release the mouse pointer from the QEMU window
* To make QEMU full screen, press Ctrl+Alt+F

To boot/install hello in UEFI mode, first install [OVMF Open Virtual Machine Firmware](https://github.com/tianocore/tianocore.github.io/wiki/OVMF) on your host side. The package name for Fedora 32 is `edk2-ovmf`

Then add these two `qemu-system-x86_64` options:
```
-bios /usr/share/edk2/ovmf/OVMF_CODE.fd \
-smbios type=0,vendor=0vendor,version=0version,date=0date,release=0.0,uefi=on \
```

#### Parallels

* Select Hardware > Boot Order.
* Expand **Advanced Settings**. Set **BIOS** to "EFI 64-bit" and in the Boot flags field, enter `vm.bios.efi=1`. 

![Screenshot](https://docs.01.org/clearlinux/latest/zh_CN/_images/parallels-07.png)

#### Proxmox VE

* Memory: 4GB (not ballooned)
* Processors: 2 (1 socket 2 cores)
* BIOS: OVMF (UEFI)
* Display: VMWare Compatible (vmware) [seems to be limited to 800x600 pixels resolution]
* Machine: Default (i440fx)
* SCSI Controller: VirtIO SCSI
* CD Drive: helloSystem ISO
* Hard Disk: At least 8GB Raw
* Network Device: vmxnet3

## Downloading

ISO images are available for download [here](https://github.com/helloSystem/ISO/releases/).

```eval_rst
important:: Images get built automatically whenever source code is committed. Not every build is tested. Builds marked as "Pre-Release" are strictly for developers, may be broken and may not even boot.
```
