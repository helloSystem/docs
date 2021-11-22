# Troubleshooting

## Notable issues

### FreeBSD logo on screen for more than five minutes

It can take up to five minutes to start the system in Live mode. If you see the FreeBSD logo on screen for more than five minutes, then something might be wrong and you might need to restart the computer.

If – after five minutes – you're reluctant to stop the computer, you can occasionally [key Ctrl-T](https://hellosystem.github.io/docs/developer/boot.html#seeing-what-the-system-is-doing-while-the-graphical-boot-screen-is-shown) to get some information about what the computer is doing. If there is no change from one snippet to the next, across three or more snippets, you may reasonably assume that the computer needs to be restarted.

* Please restart the computer. If normal use of the power button is not effective, press and hold. 
* Then, please [start the computer in verbose mode](https://hellosystem.github.io/docs/developer/boot.html#boot-in-verbose-mode) to see any relevant error messages that may help in resolving the issue.

### Boot stalls with black screen

This means that Xorg has been started but for some reason the login manager `slim` or the helloDesktop startup script `start-hello` cannot run.

* Boot in verbose mode
* Press Ctrl+Alt+F2
* Log in
* `sudo killall Xorg`
* `sudo service dbus restart`
* `sudo service slim restart`

If this does not work:

* `sudo killall Xorg`
* `startx`
* In XTerm, `sudo liveuser` (or the username you chose)
* `start-hello`

### `login:` prompt, no desktop environment

* Please make sure that your computer has at least 4GB of RAM. helloSystem currently needs at least this amount to be started in Live mode.
* The graphics hardware in your computer may not yet, or not yet easily, be usable with helloSystem. Try with a different computer, or seek help.

## Debugging application issues

When debugging application issues, it can be helpful to see what an application is actually doing. For example, if we are interested in which libraries with "menu" in their name `firefox` is loading, we can run

```
LD_DEBUG=libs firefox 2>&1 | grep -i menu
```

Or, if we are interested in which activities with "menu" in their name `firefox` is doing, we can run

```
sudo sysctl security.bsd.unprivileged_proc_debug=1
truss firefox 2>&1 | grep -e menu 
```

## Other issues

Use the *Search or jump to…* field at the head of the main [https://github.com/helloSystem/](https://github.com/helloSystem/) page – above the helloSystem logo. This special page allows an organisation-wide search, across all helloSystem repositories. Click in the field, then begin typing. 

If your issue is not already reported, you can create a new one. 

## Getting help

Please participate in our [discussion forum](https://github.com/helloSystem/hello/discussions) or [contact us](https://hellosystem.github.io/docs/developer/contact.html). 
