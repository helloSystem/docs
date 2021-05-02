# Autostart

The __Autostart__ mechanism provides an easy way to automatically start applications whenever the computer is started (to be precise, when a user is logged into a graphical desktop session). Applications can be either `.app` bundles or `.AppDir` directories.

* __System-wide autostart__: Place applications (or symlinks to applications) into the `/Applications` folder to have them started for all users of the computer

* __Per-user autostart__: Place applications (or symlinks to applications) into the `~/Applications` folder (in your home folder) to have them started for all users of the computer. You can create the folder if it does not exist yet

The `launch` command is invoked for each of those applications and launches the applications.
