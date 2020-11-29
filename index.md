# hello

```eval_rst
.. centered:: Willkommen • Welcome • 欢迎 • Bienvenue • Benvenuto • Bienvenido • ようこそ • Mabuhay • Välkommen • أهلا وسهلا • Добро пожаловать • Merhaba • Bonvenon • 歡迎光臨
```

__hello__ (also known as __helloSystem__) is a desktop system for creators with focus on simplicity, elegance, and usability. Its design follows the "Less, but better" philosophy. It is intended as a system for "mere mortals", welcoming to switchers from the Mac. [FreeBSD](https://www.freebsd.org/) is used as the core operating system. Please refer to https://github.com/helloSystem/hello if you would like to learn more about the ideas and principles behind hello.

``` .. toctree::
   :maxdepth: 2
   :caption: User Guide
   :hidden:

   index
   acknowledgements
``` 

``` .. toctree::
   :maxdepth: 2
   :caption: Developer Guide
   :hidden:

   developer/contributing
``` 

## Status

hello is currently being developed. It is not yet available for general use, but advanced users can try out continuous builds of pre-alpha ISO images that can be booted from DVD or USB storage media.

## System requirements

* 2 GHz dual core Intel/ARM 64-bit processor
* 4 GiB RAM (system memory for physical and viritualized installs)
* VGA capable of 1024x768 screen resolution
* Either a CD/DVD drive or a USB port for booting the installer media

In the future, there may also be builds for other processor architectures. We would like to bring down the RAM requirement considerably.

### Tested hardware

hello is known to boot to a graphical desktop on the following machines. Auxiliary functionality such as wireless networking, sound over HDMI, sleep, graphics acceleration, etc. has not yet been tested systematically.

* Acer Revo RL85
* Dell Inc. OptiPlex 780

### Tested virtualization environments

* VirtualBox host (on FreeBSD)
* VMware host (on Windows)

## Downloading

Continuous builds of pre-alpha ISO images are available for download [here](https://github.com/helloSystem/ISO/releases/tag/continuous-hello).

``` important:: Images get built automatically whenever source code is committed. Not every build is tested.
```

## Troubleshooting

* __Boot stalls during `Replicate system image to swap-based memdisk`__: This build of the ISO is damaged. Please wait for another continuous build to appear and try again.
* __Boots to a non-graphical `login:` prompt__: Your grahpics hardware was not detected properly. Please try on another machine.

## Reporting bugs

Please search [https://github.com/helloSystem/ISO/issues](https://github.com/helloSystem/ISO/issues) for known issues. Feel free to add to existing issues or to open new issues there.

## Discussing ideas and wishlist items

Please check [https://github.com/helloSystem/hello](https://github.com/helloSystem/hello) fist, including the [wiki](https://github.com/helloSystem/hello/wiki). Feel free to discuss ideas and wishlist items at [https://github.com/helloSystem/hello/issues](https://github.com/helloSystem/hello/issues), but please do keep in mind that in order to achieve the intended goal of simplicity, the team needs to say "no" to most wishlist items that do not further that goal.

## Contributing

This project lives from contributions by people like you.

Here is what we need help with: [Issues flagged with help-wanted](https://github.com/search?q=org%3AhelloSystem+is%3Aissue+is%3Aopen+label%3A%22help+wanted%22), and of course other contributions are also welcome.

Maybe you'd like to look into one of these: [Issues flagged with good-first-issue](https://github.com/search?q=org%3AhelloSystem+is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22&type=).

Please see the https://github.com/helloSystem/hello/blob/master/CONTRIBUTING.md page for more information.

Developers chat at `#FuryBSD` on `irc.freenode.net`. Since we are working in different timezones, do not expect immediate answers. It is best to stay connected for at least a couple of days or so.
