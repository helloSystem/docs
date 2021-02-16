# Troubleshooting

## Notable issues

### 🚫 Do not upgrade packages without first locking the `hello` package

Draft – offer simple guidance. Refer to https://github.com/helloSystem/ISO/issues/14#issuecomment-766393223 only if necessary. 

### 🚫 Do not attempt to update or upgrade FreeBSD using freebsd-update in experimental helloSystem

⚠ An upgraded system will cease to work as expected for some types of package installation/upgrade. This includes installation of Falkon. 

Draft – maybe refer to https://github.com/helloSystem/Utilities/issues/33#issuecomment-779657535 or thereabouts. 

### FreeBSD logo on screen for more than five minutes

It can take up to five minutes to start the system in Live mode. If you see the FreeBSD logo on screen for more than five minutes, then something might be wrong and you might need to restart the computer.

If – after five minutes – you're reluctant to stop the computer, you can occasionally [key Ctrl-T](https://hellosystem.github.io/docs/developer/boot.html#seeing-what-the-system-is-doing-while-the-graphical-boot-screen-is-shown) to get some information about what the computer is doing. If there is no change from one snippet to the next, across three or more snippets, you may reasonably assume that the computer needs to be restarted.

* Please restart the computer. If normal use of the power button is not effective, press and hold. 
* Then, please [start the computer in verbose mode](https://hellosystem.github.io/docs/developer/boot.html#boot-in-verbose-mode) to see any relevant error messages that may help in resolving the issue.

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
