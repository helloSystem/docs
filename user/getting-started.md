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

![helloSystem on VirtualBox in BIOS EFI mode](https://user-images.githubusercontent.com/2480569/101068320-dc2a6880-3598-11eb-9304-28655c8f17a5.png)

* VirtualBox host (on FreeBSD and on macOS), known to work in BIOS and EFI mode
* VMware host (on Windows), possibly only working in BIOS mode?

Pleaase note:

* The VM needs to be 64-bit
* The VM needs at least 4 GB of RAM which is higher than the VirtualBox default
* The boot process takes longer than you might expect; boot `-v` to see the details

Please report back about the results on your virtualization environment.

## Downloading

Pre-alpha ISO images are available for download [here](https://github.com/helloSystem/ISO/releases/).

```eval_rst
important:: Images get built automatically whenever source code is committed. Not every build is tested.
```
