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

## Building application bundles

Here is a real-world example on how to build an application bundle for a Qt application written in C++ using GitHub and [Cirrus CI](https://cirrus-ci.com/):

https://github.com/helloSystem/QHexEdit

The application gets compiled and uploaded in a fully automated process.

The resulting application bundle is provided for download in zipped form on GitHub Releases.

Please see the [`.cirrus.yml`](https://github.com/helloSystem/QHexEdit/blob/main/.cirrus.yml) file for details.

### Making an application load privately bundled libraries

If an application is supposed to load privately bundled libraries, one must patch it so that it loads privately bundled libraries from a path relative to itself (`$ORIGIN`) rather than from `/usr/local/lib`:

```
sed -i -e 's|/usr/local/lib|$ORIGIN/../lib|g' usr/local/bin/falkon
ln -s usr/local/lib .
rm usr/local/bin/falkon-e
```

This works because by coincidence the string `/usr/local/lib` has the exact same length as `$ORIGIN/../lib`. If this was not the case, one would need to either specify the rpath at compilation time, or use a tool such as `patchelf`.

### Avoiding absolute paths

For an application to be fully relocatable in the filesystem, one must take care that no absolute paths to data files (e.g., those in `/usr/share/<APPNAME>` get compiled in.

In Qt applications, void [`QStringList QStandardPaths::standardLocations(QStandardPaths::AppDataLocation);`](http://doc.qt.io/qt-5/qstandardpaths.html). According to the [Qt documentation](http://doc.qt.io/qt-5/qstandardpaths.html), this resolves to `"~/.local/share/<APPNAME>", "/usr/local/share/<APPNAME>", "/usr/share/<APPNAME>"` but clearly `/usr` is not where these things are located in an `.app` bundle.

Instead, use [`QString QCoreApplication::applicationDirPath()`](http://doc.qt.io/qt-5/qcoreapplication.html#applicationDirPath) and construct a _relative_ path to `../share/<APPNAME>` from there.

For an example, see:
https://github.com/KaidanIM/Kaidan/commit/da38011b55a1aa5d17764647ecd699deb4be437f

## Getting application metadata for running applications

Many desktop environments use XDG-style `.desktop` files to figure out which application a given window belongs to but since helloSystem is using `.app` bundles and `.AppDir` application directories this approach is not sufficient since such applications normally do not install XDG-style `.desktop` files in central locations.

Docks (and other similar applications) can find the icon that belongs to a window on the screen by the following procedure:

1. Get the Window IDs of the windows on the screen from Xorg (to simulate this, you can use the `xprop` tool)
1. Get the process ID (PID) that has launched the window with this ID from the `_NET_WM_PID` property of the Xorg window
1. Get the path of the executable and its arguments that launched this PID from the operating system, e.g., using `/proc/$PID/cmdline` (Linux) or the `procstat` command (FreeBSD)
1. From the path and the arguments figure out which element might be the relevant `.app` bundle or `.AppDir`. For example, a process might have been invoked with `sudo -E launch python3 /Applications/Some.app/Some --arguments 123`. In this case the relevant information is in a "random" location within the long list of arguments. Also consider the case `python3 /Applications/Some.app/Resources/some-executable`. In this case `some-executable` is in a subdirectory of the application bundle

A rudimentary implementation of this logic is in place in Dock in the `Utils::readInfoFromPid(quint32 pid)` and `Utils::examinePotentialBundlePath(QString path)` methods, but improvements are highly welcome.


``` .. note::
    To display the correct icons in Dock for processes running as root, users must be able to see information on processes running as root. Hence security.bsd.see_other_uids=0 must not be set in sysctl.conf for this to work.
```

## Credits

Application directories and application bundles have been used by many desktop-oriented operating systems, including RISC OS, NeXTStep/OPENSTEP, Mac OS X, and various other systems. Classic Macintosh System used single-file applications that kept resources in the Resource Fork.

* https://en.wikipedia.org/wiki/Application_directory
* http://rox.sourceforge.net/desktop/AppDirs.html
* https://en.wikipedia.org/wiki/Resource_fork
