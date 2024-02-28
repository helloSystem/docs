# Global Menu

helloSystem intends to provide a unified user experience for all applications regardless of toolkit being used by application developers.

To provide this unified user experience, it is crucial that all applications can show their commands in the system-wide global menu.

## Terminology

:::{note}
Consistent, up-to-date documentation regarding the subject of global menus is hard to find. 

Please consider submitting issues and pull requests if you can contribute to this subject.
:::

### Concepts 

* __Global menu bar__: A concept in user interface design where a system-wide widget on the screen displays the menu items (also known as "actions" in Qt) for all applications
* [__Menu__](https://github.com/helloSystem/Menu/): The application in helloSystem that shows the global menubar
* [__Status Menu__](https://wiki.ubuntu.com/CustomStatusMenuDesignGuidelines): The term used by Canonical to describe the icons in the upper-right corner of the screen that are usually used for long-running background processes
* [__System Tray__ = __Notification Area__](https://en.wikipedia.org/wiki/Notification_area): The term that describes the icons on the bottom-right corner of the screen on Windows
* [__Application (Panel) Indicators__](https://wiki.ubuntu.com/DesktopExperienceTeam/ApplicationIndicators): Another term used by Canonical to describe __Status Menus__?
* [__Status Notifiers__](): tbd

### APIs

APIs can be described in specifications, protocols, and interfaces.

* [__StatusNotifierItem spec__](https://www.freedesktop.org/wiki/Specifications/StatusNotifierItem/): "This specification defines the management of visual items, usually icons used for reporting the status of an application to the user or provide a quick access to common actions performed by that application." Similar to what "tray icons" do on Windows.
* [__DBusMenu protocol__](): Protocol for which implementations exist for Glib, Gtk, Qt (starting with Qt 2). Applications can export and import their menus (question: only indicators or all menus?) using this protocol. The specification used to be at https://people.canonical.com/~agateau/dbusmenu/spec/index.html but the link is dead as of 2020. On https://agateau.com/2009/statusnotifieritem-and-dbusmenu/ it is described as: "The goal of DBusMenu is to make it possible for applications using the StatusNotifierItem spec to send their menus over DBus, so that the workspace can display them in a consistent way, regardless of whether the application is written using Qt, GTK or another toolkit." Possibly it has significantly evolved since then? According to [__@ximion__](https://github.com/ximion), DBusMenu is a spec that transfers menus to status notifiers, and in combination with `com.canonical.AppMenu.Registrar` can be used for global menus.
* [__org.gtk.Menus interface__](https://wiki.gnome.org/Projects/GLib/GApplication/DBusAPI#org.gtk.Menus): An interface defined by Gnome that "is primarily concerned with three things: communicating menus to the client, establishing links between menus and other menus, and notifying clients of changes". Note that "To do so, it employs a number of D-Bus interfaces. These interfaces are currently considered private implementation details of GApplication and subject to change - therefore they are not documented in the GIO documentation." ([Source](https://wiki.gnome.org/Projects/GLib/GApplication/DBusAPI#org.gtk.Menus)). __How does it relate to the DBusMenu protocol, does it have an overlapping scope or is it a complement?__ According to [__@ximion__](https://github.com/ximion), the `org.gtk.Menus` interface has nothing to do with DBusMenu and was only for the Gnome Shell global menu (deprecated in Gnome). It is deprecated in Gnome Shell only, but it still used in Gtk 4.12. GNOME wants to remove a concept of menu from their apps.
* [__com.canonical.AppMenu.Registrar D-Bus Service__](): `com.canonical.AppMenu.Registrar`, an interface to register a menu from an application's window to be displayed in another window.  This manages that association between XWindow Window IDs and the dbus address and object that provides the menu using the dbusmenu dbus interface. ([Source](https://github.com/KDE/plasma-workspace/blob/master/appmenu/com.canonical.AppMenu.Registrar.xml)). "Appmenu registrar allows other applications to access any active window's application menu tree. Such a registrar is extremely useful for, e.g. implementing global menus (application menus appear in the top panel bar of the desktop environment, and for adding an application menu browser or search engine to HUDs" ([Source](https://packages.debian.org/buster/appmenu-registrar)). It serves as a central point of storing of registered menus and its mapping to windows (on X11, it is usually an X11 Window Number, I do not designed registrar for Wayland). If we need to work over DBus protocol
* [__org/appmenu D-Bus Methods__](): tbd
* [__org.kde.plasma.gmenu_dbusmenu_proxy D-Bus service__](): Translates o`org.gtk.Menus` menus to `com.canonical.dbusmenu` menus, because Qt and KDE can use only the latter.

### Implementations

Those may or may not be used in helloSystem, they are mentioned here to give an overview over the field so that technical discussions can be had.

* __Panel__: Ubuntu calls the widget at the top of the screen the "panel". In helloSystem, the rough equivalent is __Menu__.
* [__Aytana__](https://wiki.ubuntu.com/Ayatana): The Buddhist term for a "sense base" or "sense sphere". A project by Canonical to improve user experience in Ubuntu. Abandoned?
* [__AyatanaIndicators__](https://ayatanaindicators.github.io/): "The Ayatana Indicators project is the continuation of Application Indicators, a technology developed by Canonical for the Unity desktop. Application Indicators are a GNOME implementation of the StatusNotifierItem Specification (SNI) that was originally submitted to freedesktop.org by KDE. The Ayatana Indicator project intends to become the new upstream for application indicators and associated projects with a focus on making Ayatana Indicators a desktop agnostic technology.". With Ubuntu now using GNOME rather than Unity, it is no longer developed by Canonical. UBports, MATE and XFCE are adopting AyatanaIndicators and Ubuntu are starting to migrate to it in 21.04. Some people say  that StatusNotifierItems should be preferred since they are already more widely supported across the various desktops
* [__Application Menu or appmenu__](https://wiki.ubuntu.com/DesktopExperienceTeam/ApplicationMenu): As part of Aytana, Canonical has produced an implementation called `indicator-appmenu` which re-routes Gtk and Qt menus over `dbusmenu` so that they appear in the panel
* [__dbusmenu__](https://wiki.ubuntu.com/DesktopExperienceTeam/ApplicationIndicators#Software_Architecture): Library by Canonical implementing the transport protocol between the applications and the panel
* [__libappindicator__](https://wiki.ubuntu.com/DesktopExperienceTeam/ApplicationIndicators#Software_Architecture): Library by Canonical to register icons and menus and internally uses dbusmenu to publish context menus over dbus. Needed for some applications (e.g., screenkey) to show icons in the upper right hand corner of the menu (system tray/notification area). The same as [`indicator-application`](https://launchpad.net/indicator-application)? According to @sunweaver, libappindicator is unmaintained as of late 2022 and [libayatana-appindicator](https://github.com/AyatanaIndicators/libayatana-appindicator) is the current upstream
* [__MenuModel__](): Used by Gtk
* [__JAyatana__](): Supposedly allows for displaying global menus in Java Swing applications (such as Netbeans). JetBrains now supports Global Menus without JAyatana.
* [__Airyx DBusKit__](https://github.com/mszoek/airyx/tree/main/DBusKit): Airyx DBusKit implements a subset of D-Bus needed to support sending menus of **AppKit** applications to the global menu bar
* [__GNUstep libs-dbuskit__](https://github.com/gnustep/libs-dbuskit): The DBusKit framework provides GNUstep Objective-C applications with bindings for the D-Bus inter-process communication system

## Libraries involved

The following libraries are involved in allowing applications to show their menu items in the global menu.

:::{note}
This list is probably incomplete.

Please consider submitting issues and pull requests if you can contribute to this subject.
:::

### libappindicator

```text
/usr/local/lib/libappindicator3.so.1
/usr/local/lib/libappindicator3.so.1.0.0
/usr/local/lib/libappindicator3.so
/usr/local/lib/libappindicator3.a
```

* Author: Ted Gould, Canonical
* Description: A library to allow applications to export a menu into the Unity Menu bar. Based on KSNI it also works in KDE and will fallback to generic Systray support if none of those are available.
* Bugtracker: https://launchpad.net/libappindicator
* Purpose: Needed for some applications (e.g., `screenkey`) to show icons in the upper right hand corner of the menu (system tray/notification area)
* Theory of operation: operated on DBusMenu protocol, and it used by some programs to implement StatusNotifier tray.
* Status: active
* Issues: tbd
* Installed by package: `libappindicator`

### libappmenu-gtk-module library from vala-panel-appmenu repository

```text
/usr/local/lib/gtk-2.0/modules/libappmenu-gtk-module.so
/usr/local/lib/gtk-3.0/modules/libappmenu-gtk-module.so
```

* Author: [__@rilian-la-te__](https://github.com/rilian-la-te). This module was originally used in Ubuntu's Unity
Desktop Environment, but it lives on as part of the Vala project.
* Description: 
* Bugtracker: https://github.com/rilian-la-te (upstream), https://github.com/NorwegianRockCat/FreeBSD-my-ports (FreeBSD Port)
* Purpose: Make Gtk applications export their menus to a global menu bar
* Theory of operation: Gtk module that strips menus from all Gtk
programs, converts to them MenuModel and send to them AppMenu
(sometimes called a global menu bar). It was a fork of `unity-gtk-module`, but now it is completely separate.
* Status: active
* Issues: Only if `GTK_MODULES=appmenu-gtk-module` is exported the menus in e.g. Audacity get shown in the global menu bar. Supposedly used by Chrome. Upstream documentation [advises](https://github.com/rilian-la-te/vala-panel-appmenu#post-build-instructions) "Install `libdbusmenu-glib libdbusmenu-gtk3 libdbusmenu-gtk2` to get Chromium/Google Chrome to work". Firefox can use Global Menu only if built with Ubuntu patches. If not - there is no possibility to use Global Menu in Firefox.
* Installed by package: `appmenu-gtk-module`

### unity-gtk-module

If you use `appmenu-gtk-module`, then you do not need this, because `appmenu-gtk-module` has same fuctionality.
:::{note}
tbd
:::

* Author: tbd
* Description: tbd
* Bugtracker: tbd
* Purpose: tbd
* Theory of operation: tbd
* Status: <active|retired>. "Unity" = Deprecated? According to @sunweaver, unity-gtk-module is (sort of) unmaintained as of late 2022 and [appmenu-gtk-module](https://gitlab.com/vala-panel-project/vala-panel-appmenu/-/tree/master/subprojects/appmenu-gtk-module) is a more active alternative
* Issues: Not in ports? Is this an issue, preventing us from some applications to work properly?
* Installed by package: Not in ports? (In Ubuntu, `sudo apt-get install unity-gtk-module-common unity-gtk2-module unity-gtk3-module`)
    
### libappmenu-gtk2-parser and libappmenu-gtk3-parser

```text
/usr/local/lib/libappmenu-gtk2-parser.so
/usr/local/lib/libappmenu-gtk2-parser.so.0
/usr/local/lib/libappmenu-gtk3-parser.so
/usr/local/lib/libappmenu-gtk3-parser.so.0
```

* Author: tbd
* Description: tbd
* Bugtracker: tbd
* Purpose: tbd
* Theory of operation: tbd
* Status: <active|retired>
* Issues: tbd
* Installed by package: `tbd`

### libdbusmenu-glib

```text
/usr/local/lib/libdbusmenu-glib.so
/usr/local/lib/libdbusmenu-glib.so.4
/usr/local/lib/libdbusmenu-glib.so.4.0.12
```

* Author: tbd
* Description: GLib implementation of the DBusMenu protocol.
* Bugtracker: https://github.com/AyatanaIndicators/libdbusmenu/
* Purpose: "A library to allow applications to provide simple indications of
information to be displayed to users of the application through the interface shell" ([Source](https://github.com/AyatanaIndicators/libdbusmenu/blob/master/libdbusmenu-glib/dbus-menu.xml))
* Theory of operation: tbd
* Status: <active|retired>
* Issues: tbd
* Installed by package: `libdbusmenu`

### libdbusmenu-gtk3

```text
/usr/local/lib/libdbusmenu-gtk3.so
/usr/local/lib/libdbusmenu-gtk3.so.4
/usr/local/lib/libdbusmenu-gtk3.so.4.0.12
```

* Author: tbd
* Description: Gtk implementation of the DBusMenu protocol
* Bugtracker: tbd
* Purpose: tbd
* Theory of operation: tbd. Why does Gtk need an extra implementation when it is already implemented in GLib (via `libdbusmenu-glib.so`) with Gtk uses?
* Status: <active|retired>
* Issues: tbd
* Installed by package: `libdbusmenu`

### libdbusmenu-qt5

```text
/usr/local/lib/libdbusmenu-qt5.so
/usr/local/lib/libdbusmenu-qt5.so.2
/usr/local/lib/libdbusmenu-qt5.so.2.6.0
```

* Author: tbd
* Description: Qt5 implementation of the DBusMenu protocol
* Bugtracker: https://launchpad.net/libdbusmenu-qt
* Purpose: tbd
* Theory of operation: tbd
* Status: active
* Issues: tbd
* Installed by package: `libdbusmenu-qt`

### Kf5 Appmenu Plugin

```text
/usr/local/lib/qt5/plugins/kf5/kded/appmenu.so
```

* Author: tbd
* Description: tbd
* Bugtracker: tbd
* Purpose: tbd
* Theory of operation: tbd
* Status: <active|retired>
* Issues: tbd
* Installed by package: `tbd`

### Kf5 Plasma Applet Appmenu Plugin

```text
/usr/local/lib/qt5/plugins/plasma/applets/plasma_applet_appmenu.so
```

* Author: tbd
* Description: tbd
* Bugtracker: tbd
* Purpose: tbd
* Theory of operation: tbd
* Status: <active|retired>
* Issues: tbd
* Installed by package: `tbd`

### Kf5 Plasma Private libappmenuplugin

```text
/usr/local/lib/qt5/qml/org/kde/plasma/private/appmenu/libappmenuplugin.so
```

* Author: tbd
* Description: tbd
* Bugtracker: tbd
* Purpose: tbd
* Theory of operation: tbd
* Status: <active|retired>
* Issues: tbd
* Installed by package: `tbd`

### wxGtk libwx_gtk3u_core

```text
/usr/local/lib/libwx_gtk3u_core-3.1.so
/usr/local/lib/libwx_gtk3u_core-3.1.so.4
/usr/local/lib/libwx_gtk3u_core-3.1.so.4.0.0
```

* Author: wxWidgets authors
* Description: wxWidgets is a C++ library that lets developers create applications for Windows, Mac OS X, Linux and other platforms with a single code base. On FreeBSD the Gtk toolkit is used
* Bugtracker: https://www.wxwidgets.org/
* Purpose: tbd
* Theory of operation: Applications written with wxWidgets (e.g., Audacity) use this to display their UI with Gtk on FreeBSD
* Status: active
* Issues: Requires the (undocumented?) `UBUNTU_MENUPROXY` environment variable not to be set to `0` or `<empty>`
* Installed by package: `wx31-gtk3`

## Files involved

* `/usr/local/share/dbus-1/interfaces/com.canonical.AppMenu.Registrar.xml` (comes with the `plasma5-plasma-workspace` package). It is needed for the correct functioning of Global Menus - it is served as main point of storing dictionary (keyed by XWindow) of a `com.canonical.dbusmenu` object. It is needed for all applications using that protocol. There should be only one registrar running, but installed - as many of you want. 
* `com.canonical.dbusmenu.xml` - it is a reference XML of Canonical DBusMenu protocol, used by StatusNotifier trays and by Qt applications with Global Menu.

## Environment variables involved

### GTK_MODULES=appmenu-gtk-module

Only if `GTK_MODULES=appmenu-gtk-module` is exported the menus in e.g. Audacity get shown in the global menu bar.

### UBUNTU_MENUPROXY

As of 2021, the (undocumented?) `UBUNTU_MENUPROXY` environment variable is referenced in

```text
/usr/local/lib/libwx_gtk3u_core-3.1.so.4.0.0
/usr/local/lib/gtk-3.0/modules/libappmenu-gtk-module.so
/usr/local/lib/gtk-2.0/modules/libappmenu-gtk-module.so
```

Audacity is an example for an application that uses `libwx_gtk3u_core-3.1.so.4`.

* Apparently `UBUNTU_MENUPROXY` __must not__ be set to `0` or `<empty>` e.g., for Audacity to work
* Apparently unsetting it still makes the global menu work for Audacity
* Apparently setting it to a random value still makes the global menu work for Audacity
* According to [this](https://github.com/electron/electron/issues/709#issuecomment-59207492), `UBUNTU_MENUPROXY` should be set to `libappmenu.so`?

:::{note}
Please consider submitting issues and pull requests if you know how UBUNTU_MENUPROXY is supposed to work. Is it documented?
:::

Ultimaker Cura (which does not have a working global menu integration by default) contains a note in `/usr/local/lib/python3.7/site-packages/UM/Application.py` saying

```py
# For Ubuntu Unity this makes Qt use its own menu bar rather than pass it on to Unity.
os.putenv("UBUNTU_MENUPROXY", "0")
```

Changing this to `"1"` does not make any difference for Cura, though.

## Executables involved

_To be written._

### Chromium, Chrome

Starting with version 0.7.0 of helloSystem, Menu can handle Chrome and (patched) Firefox and Thunderbird, thanks Jesper Schmitz Mouridsen ([__jsm222__](https://github.com/jsm222/)).

### Patches needed for Firefox and Thunderbird

Firefox and Thunderbird need substantial source code patches to make global menus work:

* https://aur.archlinux.org/cgit/aur.git/tree/unity-menubar.patch?h=firefox-appmenu. See https://github.com/airyxos/Firefox_app for a FreeBSD implementation
* https://aur.archlinux.org/cgit/aur.git/tree/0001-Use-remoting-name-for-GDK-application-names.patch?h=firefox-appmenu

For Firefox, this topic is being discussed upstream:
https://bugzilla.mozilla.org/show_bug.cgi?id=1419151

FreeBSD Ports files for patched Firefox and Thunderbird by Jesper Schmitz Mouridsen ([__jsm222__](https://github.com/jsm222/)) are available at
* https://github.com/jsm222/helloDesktop/tree/main/www/firefox
* https://github.com/jsm222/helloDesktop/tree/main/mail/thunderbird

Packages of patched Firefox and Thunderbird are available at http://build.schmitz.computer/packages/122amd64-quarterly (see https://wiki.freebsd.org/helloDesktop for details).

helloSystem versions 0.7.0 and up come with this repository enabled. To enable it manually:

```console
$ cat > /usr/local/etc/pkg/repos/helloDesktop.conf <<\EOF
helloDesktop: {
        url: "pkg+http://build.schmitz.computer/packages/${ABI}-mozillapatched",
        mirror_type: "srv",
        enabled: yes,
        signature_type: "pubkey",
        pubkey: "/usr/local/etc/ssl/certs/jsm222.cert",
        priority: 100
}
EOF

$ cat > /usr/local/etc/ssl/certs/jsm222.cert <<\EOF
-----BEGIN PUBLIC KEY-----
MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA5gEt92AHUkYkZH2Q2nP3
2/Wu7gxbMEno5iqi1ea327lHmhJB18E0mW9dKYgxz74PbbTAmyaMdY4G1vn3cStp
jKVnrOCsNboaZ1L6riYFTjZX0pVAQYdtblCNjTf92X1kk8Yp1jy3baH8s19IKVWD
jX+2j33BOjRH3jbiLxdPu51wPItDUM4UU+mdrMH2+RgHjVX3ZkgRe/bYxMgrYBQg
roEwp0Pv9DbDQ0Vx3qIBJahQ7zfDCWZI1urr85/kM58KXYLt1YHW+vRd3scOm1IE
mRON0zVO2f8+obzy3lLNnZj/XIWxh+LNI4kmmdoHMksysYtrRz1bpcnsY8qOe4g3
X7q+i8k0JaaMwwD9YvKf6HyQ09rFt3WqV2AAOwR0835oHxCENJJFcoUCMCaKjNSF
OZyuYKKPqSm8BKj/QaoXBIF1fQJBJzrINYSUj4/M6TWKVTSO8H4s+eiqfD7FYJ3h
jSZ2ubydtTOef1Tk79OVoo8Ns7FqzCK7ffOvELxuY2OMDIKrw0sCfpkI9uM5Dfrr
rYXn4dwvZLwB+tnBbKBXIfjAvwqjHeWfzqgUHSk/Slqh7UEYL+BnLfHxLMVN0Omk
gFM24eVEKju1PHkBDHVAD+NGfq4g/hcbAbcrtjxDrs1ztdwjtCJmFNcEYFjz0DRc
q9cTv5oaRy9FQy0NdGwGuqUCAwEAAQ==
-----END PUBLIC KEY-----
EOF

$ sudo pkg install firefox thunderbird
```

Since the helloDesktop repository has `priority: 100`, you should see:

```console
New packages to be INSTALLED:
        firefox-94.0.1_1,2 [helloDesktop]
        thunderbird: 91.3.0_1 [helloDesktop]
```

Note the `helloDesktop`, indicating that these packages will be installed from the helloDesktop repository provided by [__jsm222__](https://github.com/jsm222/) rather than from the FreeBSD repository. In general, we aim to use software that is in the official FreeBSD packages, so we hope that those ports will be upstreamed.

### GMenu-DBusMenu-Proxy

```text
/usr/local/bin/gmenudbusmenuproxy 
```

* Author: Kai Uwe Broulik (KDE)
* Description: tbd
* Bugtracker: https://phabricator.kde.org/D10461
* Purpose: tbd. Translate between the org.gtk.Menus interface used by Gtk applications and what is needed to satisfy the KDE global menu bar (and helloSystem Menu which is derived from it)? (Why does KDE need something special?)
* Theory of operation: "This application finds windows using GTK GMenu DBus interfaces and forwards them through DBusMenu. (...) LibreOffice with appmenu-gtk-module (...) Works with Gimp or Inkscape if you have appmenu-gtk-module (there's GTK2 and GTK3 variants) installed and GTK_MODULES=appmenu-gtk-module environment variable set." ([Source](https://phabricator.kde.org/transactions/detail/PHID-XACT-DREV-jz6tqizldlvwmv6/), [more information](https://blog.broulik.de/2018/03/gtk-global-menu/))
* Status: <active|retired>
* Issues: Can we get it "standalone", without KDE Plasma?
* Installed by package: `plasma5-plasma-workspace`

## Debugging with Qt 5 D-Bus Viewer

The __Qt 5 D-Bus Viewer__ utility may be useful in debugging global menus.


:::{note}
Please consider submitting issues and pull requests if you can contribute to this subject.
:::

### Getting the menus for a Qt application knowing the Xorg window ID

* Open Terminal
* Enter `xprop`
* Click on the Terminal window
* We see `_KDE_NET_WM_APPMENU_OBJECT_PATH(STRING) = "/MenuBar/1"` and `_KDE_NET_WM_APPMENU_SERVICE_NAME(STRING) = ":1.59"` (actual numbers might be different from this example)
* Open Qt 5 D-Bus Viewer
* Under "Services", click on ":1:59", under "Methods", click on "MenuBar/", "1/"
* KDE follows `com.canonical.dbusmenu` protocol, you can see its definition in XML file mentioned earlier.

### Getting the menus for a Gtk application

* Open GIMP
* Open Qt 5 D-Bus Viewer
* Under "Services", click on "org.gimp.GIMP.UI", under "Methods", click on "org/", "appmenu/", "gtk/", "window/", "0/", "org.gtk.Actions/", "Method: List"
* The names of the actions in the GIMP menus appear at the bottom of the window
* Under "Services", click on "org.gimp.GIMP.UI", under "Methods", click on "org/", "appmenu/", "gtk/", "window/", "0/", "org.gtk.Actions/", "Method: DescribeAll"
* __Qt 5 D-Bus Viewer crashes__
* __Then what? How can one get the actual menus?__
* GTK applications followed `org.gtk.Menus` and `org.gtk.Actions` protocol, you can see how it works inside KDE's gmenu-dbusmenu-proxy.

## Limitations

Applications running as root currently cannot show global menus due to the D-Bus architecture.

:::{note}
Possibly some sort of proxy would be needed to allow applications that were invoked via `sudo -E` to display their menus in the global menu of the user running the desktop session.

Please consider contributing ideas and code if you are interested in this topic.
:::

## Implementations for other desktop systems

* [Fildem](https://github.com/gonzaarcr/Fildem) for GNOME
* [CutefishOS](https://twitter.com/cutefishos/status/1401420887568441345)
* [vala-panel-appmenu](https://gitlab.com/vala-panel-project/vala-panel-appmenu) for XFCE and MATE.
