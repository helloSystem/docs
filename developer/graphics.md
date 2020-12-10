# Graphics hardware autoconfiguration

helloSystem uses `initgfx` for the automatic configuration of the graphics hardware in your computer.

## Theory of operation

`initgfx` consists of the following files and directories:

```
/etc/rc.d/initgfx
/etc/initgfx_device.db
/etc/initgfx_xorg.cfg
/usr/local/nvidia/<version>/<contents of the driver tgz>
/usr/local/etc/X11/xorg.conf.d/<dynamically generated> # defined by path_xorg_cfg_dir
```

`initgfx` calculates a config ID which is a MD5 checksum of the output of `sysctl
dev.vgapci | sort`. If the file `/var/initgfx_config.id` exists, check if
its content matches the config ID. If that is the case, load the modules
set via the `rc.conf` variable `initgfx_kmods`, and exit. If the file
`/var/initgfx_config.id` does not exist, or its content does not match the
config ID, try to auto-detect the accelerated graphics driver. Use `xinit`
to test if the X server starts, change `initgfx_kmods`, write a new xorg
config file, and save the new config ID if the test was successful.
Otherwise, as a fallback, write a xorg config file for the VESA or SCFB
driver depending on whether the system was booted via BIOS or EFI.

[Source](https://github.com/nomadbsd/NomadBSD/commit/a346f134aaca1cdc164346f63808abdb4d8919e3)

## Disabling the graphics driver menu

If you want to disable the graphics driver menu, add

`initgfx_menu="NO"` to `/etc/rc.conf`.

By default, initgfx will try autodetection, but you can instead define a default driver to use by setting `initgfx_default` to `scfb` or `vesa` in `/etc/rc.conf`.


## Disabling the automatic graphics driver setup

If you want to create your own graphics driver settings, you can disable initgfx by adding

`initgfx_enable="NO"` to `/etc/rc.conf`.

## Troubleshooting

If applications that are using OpenGL crash on Nvidia systems, then it may be that the Nvidia driver was correctly loaded but the wrong Xorg configuration has been loaded, not actually using the Nvidia driver. This can happen when initgfx writes the dynamically generated Xorg configuration to `path_xorg_cfg_dir` (which points to `/usr/local/etc/X11/xorg.conf.d/` by default) but other files have been placed by other packages or the user into, e.g., `/etc/X11/xorg.conf.d`. You can verify which Xorg configuration directory was used by Xorg with `cat /var/log/Xorg.0.log | grep Using.config`. Seemingly Xorg cannot combine configuration stored in multiple `xorg.conf.d` directories.
