# Troubleshooting

## Notable issues

### FreeBSD logo on screen for more than five minutes

Something might be wrong, but relevant information is *muted* by the logo. You will probably need to stop the computer. If normal use of the power button is not effective, press and hold. 

If – after five minutes – you're reluctant to stop the computer, you can occasionally [key Ctrl-T](https://hellosystem.github.io/docs/developer/boot.html#seeing-what-the-system-is-doing-while-the-graphical-boot-screen-is-shown) to reveal isolated snippets of information. If there's no change from one snippet to the next, across three or more snippets, you may reasonably assume that a stop will be required. 

For a more useful view of relevant information: 

* after stopping the computer, you can [temporarily stop the muting and boot (start) the computer in verbose mode](https://hellosystem.github.io/docs/developer/boot.html#boot-in-verbose-mode).

### Boot stalls during `Replicate system image to swap-based memdisk`(seen during verbose boot)

This affects some computers with some builds of the ISO. If you encounter this issue with your computer, please await the next ISO or try with a different computer. 

### `login:` prompt, no desktop environment

Some graphics hardware is not yet, or not easily, usable with helloSystem. Try with a different computer, or seek help.

## Other issues

Use the *Search or jump to…* field at the head of the main [https://github.com/helloSystem/](https://github.com/helloSystem/) page – above the helloSystem logo. This special page allows an organisation-wide search, across all helloSystem repositories. Click in the field, then begin typing. 

If your issue is not already reported, you can create a new one. 

Frequently updated areas include [ISO issues](https://github.com/helloSystem/ISO/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc). 

## Getting help

Please [contact us](https://hellosystem.github.io/docs/developer/contact.html). 
