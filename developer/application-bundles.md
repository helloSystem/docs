# Application Bundles

helloSystem uses __application bundles__ to manage native applications. Whenever possible, application bundles are used. XDG-style `.desktop` files are considered legacy and should be avoided.

## Benefits

Applications shipped as application bundles can

* Easily be moved around in the filesystem (relocation)
* Easily be copied to e.g., another machine or a network share
* Easily be copied on the local machine to get a second instance of the same application (e.g., to make changes to it while keeping the original around)
* Easily be deleted by moving to the Trash
* Easily be managed without the need for a package manager
* Easily be modified (e.g., changing the icon) without any side effects to other parts of the system
* Easily be distributed (e.g., in archives like zip files or in disk images) without the need for packaging
* Easily be understood by switchers coming from other operating systems with similar application distribution formats

## Application bundle formats

### `.app` bundles

helloSystem supports simplified GNUstep-style `.app` bundles.

Minimal requirements:

```
./Application.app
./Application.app/Application <-- (link to) the executable to be launched when Application.app is double clicked
./Application.app/Resources/Application.png <-- the application icon (png format)
```

In order to realize the full intended functionality, additional metadata may be required (such as localized application name, version, supported file formats, etc.). Possibly the GNUstep metadata format is sufficient for this.

### `.AppDir` bundles

helloSystem supports simplified ROX-style `.AppDir` bundles.

Minimal requirements:

```
./Application.AppDir
./Application.AppDir/AppRun <-- (link to) the executable to be launched when Application.app is double clicked
./Application.AppDir/.DirIcon <-- the application icon (png format)
```

In order to realize the full intended functionality, additional metadata may be required (such as localized application name, version, supported file formats, etc.). Possibly the ROX AppDir specification is not sufficient for this and may need to be amended (to be determined).

### Wrappers for legacy packages

helloSystem supports applications that are not shipped in bundle formats yet. These can be bridged by __wrapper bundles__, application bundles that merely launch (but do not contain) the payload application (which may be installed in traditional ways).

A __desktop2app__ tool ships with helloSystem that automates the creation of such wrappers.

Please note that the use of wrapper bundles is discouraged and is only available as a bridge technology for backward compatibility with existing application packages.

## Getting application metadata for running applications

Many desktop environments use XDG-style `.desktop` files to figure out which application a given window belongs to but since helloSystem is using `.app` bundles and `.AppDir` application directories this approach is not sufficient since such applications normally do not install XDG-style `.desktop` files in central locations.

Docks (and other similar applciations) can find the icon that belongs to a window on the screen by the following procedure:

1. Get the Window IDs of the windows on the screen from Xorg (to simulate this, you can use the `xprop` tool)
1. Get the process ID (PID) that has launched the window with this ID from the `_NET_WM_PID` property of the Xorg window
1. Get the path of the executable and its arguments that launched this PID from the operating system, e.g., using `/proc/$PID/cmdline` (Linux) or the `procstat` command (FreeBSD)
1. From the path and the arguments figure out which element might be the relevant `.app` bundle or `.AppDir`. For example, a process might have been invoked with `sudo -E launch python3 /Applications/Some.app/Some --arguments 123`. In this case the relevant information is in a "random" location within the long list of arguments. Also consider the case `python3 /Applications/Some.app/Resources/some-executable`. In this case `some-executable` is in a subdirectory of the application bundle

A rudimentary implementation of this logic is in place in Dock in the `Utils::readInfoFromPid(quint32 pid)` and `Utils::examinePotentialBundlePath(QString path)` methods, but improvements are highly welcome.


``` .. note::
    To display the correct icons in Dock for processes running as root, users must be able to see information on processes running as root. Hence security.bsd.see_other_uids=0 must not be set in sysctl.conf for this to work.
```

## Credits

Application directories and applciation bundles have been used by many desktop-oriented operating systems, including RISC OS, NeXTStep/OPENSTEP, Mac OS X, and various other systems. Classic Macintosh System used single-file applications that kept resources in the Resource Fork.

* https://en.wikipedia.org/wiki/Application_directory
* http://rox.sourceforge.net/desktop/AppDirs.html
* https://en.wikipedia.org/wiki/Resource_fork
