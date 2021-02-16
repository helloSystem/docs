# Troubleshooting

## Notable issues

### 🚫 Do not upgrade packages without first locking the `hello` package

If you intend to run `pkg upgrade`, you must run this first: 

`sudo pkg lock hello`

A future release of helloSystem will not require this lock. 

### 🚫 Do not attempt use of freebsd-update commands with experimental helloSystem 

⚠ An upgrade from FreeBSD `12.1-RELEASE` will cause helloSystem to cease working as expected for some types of package installation/upgrade. This includes installation of Falkon. 

Technically: [Locking out root! – UNIX Administratosphere](https://administratosphere.wordpress.com/2007/11/01/locking-out-root/) describes the approach to locking that's taken by Mac OS X, and by currently available versions of helloSystem. Whilst not problematic with Apple's operating system, this approach is troublesome in the context of helloSystem because some types of [freebsd-update(8)](https://www.freebsd.org/cgi/man.cgi?query=freebsd-update(8)) command [must be run as root](https://cgit.freebsd.org/src/tree/usr.sbin/freebsd-update/freebsd-update.sh?id=48ffe56ac5b7adb5b851d32be12b2ec0f13705a4#n553). Advanced users may choose to: 

* enable the `root` user, and set a password

– after which, operating system updates and upgrades may be performed without difficulty. 

### FreeBSD logo on screen for more than five minutes

With some hardware – particularly where the live system is written to a USB drive that's low-spec – it can take more than five minutes to start the system in live mode. If you see the FreeBSD logo on screen for longer, then something might be wrong and you might need to stop the computer. If you're reluctant to stop the computer, you can [occasionally key](https://hellosystem.github.io/docs/developer/boot.html#seeing-what-the-system-is-doing-while-the-graphical-boot-screen-is-shown) <kbd>Ctrl</kbd>-<kbd>T</kbd> to get some information about what the computer is doing. 

If there is no change from one snippet of information to the next, across three or more snippets, you may reasonably assume that the computer must be started in a different way:

1. stop the computer – if normal use of the power button is not effective, press and hold
2. [start in verbose mode](https://hellosystem.github.io/docs/developer/boot.html#boot-in-verbose-mode) to view error messages that will help to explain or resolve the issue.

### Boot stalls during `Replicate system image to swap-based memdisk`(seen during verbose boot)

This affects some computers with some builds of the ISO. If you encounter this issue with your computer, please await the next ISO or try with a different computer. 

### `login:` prompt, no desktop environment

* Please make sure that your computer has at least 4GB of RAM. helloSystem currently needs at least this amount to be started in Live mode.
* The graphics hardware in your computer may not yet, or not yet easily, be usable with helloSystem. Try with a different computer, or seek help.

## Other issues

Use the *Search or jump to…* field at the head of the main [https://github.com/helloSystem/](https://github.com/helloSystem/) page – above the helloSystem logo. This special page allows an organisation-wide search, across all helloSystem repositories. Click in the field, then begin typing. 

If your issue is not already reported, you can create a new one. 

## Getting help

Please [contact us](https://hellosystem.github.io/docs/developer/contact.html). 
