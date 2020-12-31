# Global Menu

helloSystem intends to provide a unified user experience for all applications regardless of toolkit being used by application developers.

To provide this unified user experience, it is crucial that all applications can show their commands in the system-wide global menu.

## Terminology

``` .. note::
    Consistent, up-to-date documentation reagarding the subject of global menus is hard to find. 

    Please consider submitting issues and pull requests if you can contribute to this subject.
```

### Concepts 

* __Global menu bar__: A concept in user interface design where a system-wide widget on the screen displays the menu items (also known as "actions" in Qt) for all applications
* [__Menu__](https://github.com/helloSystem/Menu/): The application in helloSystem that shows the global menubar
* [__Status Menu__](https://wiki.ubuntu.com/CustomStatusMenuDesignGuidelines): The term used by Canonical to describe the icons in the upper-right corner of the screen that are usually used for long-running background processes
* [__System Tray__ = __Notification Area__](https://en.wikipedia.org/wiki/Notification_area): The term that describes the icons on the bottom-right corner of the screen on Windows
* [__Application (Panel) Indicators__](https://wiki.ubuntu.com/DesktopExperienceTeam/ApplicationIndicators): Another term used by Canonical to describe __Status Menus__?

### APIs

APIs can be described in specifications, protocols, and interfaces.

* [__DBusMenu protocol__](): Protocol for which implementations exist for Glib, Gtk, Qt (starting with Qt 2). Applications can export and import their menus (question: only indicators or all menus?) using this protocol. The specification used to be at https://people.canonical.com/~agateau/dbusmenu/spec/index.html but the link is dead as of 2020. On https://agateau.com/2009/statusnotifieritem-and-dbusmenu/ it is described as: "The goal of DBusMenu is to make it possible for applications using the StatusNotifierItem spec to send their menus over DBus, so that the workspace can display them in a consistent way, regardless of whether the application is written using Qt, GTK or another toolkit." Possibly it has significantly evolved since then?
* [__org.gtk.Menus interface__](https://wiki.gnome.org/Projects/GLib/GApplication/DBusAPI#org.gtk.Menus): An interface defined by Gnome that "is primarily concerned with three things: communicating menus to the client, establishing links between menus and other menus, and notifying clients of changes". Note that "To do so, it employs a number of D-Bus interfaces. These interfaces are currently considered private implementation details of GApplication and subject to change - therefore they are not documented in the GIO documentation." ([Source](https://wiki.gnome.org/Projects/GLib/GApplication/DBusAPI#org.gtk.Menus)). __How does it relate to the DBusMenu protocol, does it have an overlapping scope or is it a complement?__

### Implementations

Those may or may not be used in helloSystem, they are mentioned here to give an overview over the field so that technical discussions can be had.

* __Panel__: Ubuntu calls the widget at the top of the screen the "panel". In helloSystem, the rough equivalent is __Menu__.
* [__Aytana__](https://wiki.ubuntu.com/Ayatana): The Buddhist term for a "sense base" or "sense sphere". A project by Canonical to improve user experience in Ubuntu. Abandoned?
* [__Application Menu or appmenu__](https://wiki.ubuntu.com/DesktopExperienceTeam/ApplicationMenu): As part of Aytana, Canonical has produced an implementation called `indicator-appmenu` which re-routes Gtk and Qt menus over `dbusmenu` so that they appear in the panel
* [__dbusmenu__](https://wiki.ubuntu.com/DesktopExperienceTeam/ApplicationIndicators#Software_Architecture): Library by Canonical implementing the transport protocol between the applications and the panel
* [__libappindicator__](https://wiki.ubuntu.com/DesktopExperienceTeam/ApplicationIndicators#Software_Architecture): Library by Canonical to register icons and menus and internally uses dbusmenu to publish context menus over dbus. The same as [`indicator-application`](https://launchpad.net/indicator-application)?
* [__MenuModel__](): Used by Gtk
* [__JAyatana__](): Supposedly allows for displaying global menus in Java Swing applications (such as Netbeans and the JetBrains suite of IDEs)

## Libraries involved

The following libraries are involved in allowing applications to show their menu items in the global menu.

``` .. note::
    This list is probably incomplete.

    Please consider submitting issues and pull requests if you can contribute to this subject.
```

### libappmenu-gtk-module library from vala-panel-appmenu repository

```
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
(sometimes called a global menu bar). `unity-gtk-module` is used as a backend, and thus must also be installed
* Status: active
* Issues: Supposedly used by Firefox and Chrome but those applications are not functional with Menu in helloSystem yet. Upstream documentation [advises](https://github.com/rilian-la-te/vala-panel-appmenu#post-build-instructions) "Install `libdbusmenu-glib libdbusmenu-gtk3 libdbusmenu-gtk2` to get Chromium/Google Chrome to work"
* Installed by package: `appmenu-gtk-module`

### unity-gtk-module

Currently __not__ used in helloSystem. Do we need it?

```
tbd
```

* Author: <tbd>
* Description: <tbd>
* Bugtracker: <tbd>
* Purpose: <tbd>
* Theory of operation: <tbd>
* Status: <active|retired>
* Issues: Not in ports? Is this an issue, preventing us from some applications to work properly?
* Installed by package: Not in ports? (In Ubuntu, `sudo apt-get install unity-gtk-module-common unity-gtk2-module unity-gtk3-module`)
    
### libappmenu-gtk2-parser and libappmenu-gtk3-parser

```
/usr/local/lib/libappmenu-gtk2-parser.so
/usr/local/lib/libappmenu-gtk2-parser.so.0
/usr/local/lib/libappmenu-gtk3-parser.so
/usr/local/lib/libappmenu-gtk3-parser.so.0
```

* Author: <tbd>
* Description: <tbd>
* Bugtracker: <tbd>
* Purpose: <tbd>
* Theory of operation: <tbd>
* Status: <active|retired>
* Issues: <tbd>
* Installed by package: `<tbd>`

### libdbusmenu-glib

```
/usr/local/lib/libdbusmenu-glib.so
/usr/local/lib/libdbusmenu-glib.so.4
/usr/local/lib/libdbusmenu-glib.so.4.0.12
```

* Author: <tbd>
* Description: GLib implementation of the DBusMenu protocol
* Bugtracker: <tbd>
* Purpose: <tbd>
* Theory of operation: <tbd>
* Status: <active|retired>
* Issues: <tbd>
* Installed by package: `libdbusmenu`

### libdbusmenu-gtk3

```
/usr/local/lib/libdbusmenu-gtk3.so
/usr/local/lib/libdbusmenu-gtk3.so.4
/usr/local/lib/libdbusmenu-gtk3.so.4.0.12
```

* Author: <tbd>
* Description: Gtk implementation of the DBusMenu protocol
* Bugtracker: <tbd>
* Purpose: <tbd>
* Theory of operation: <tbd>
* Status: <active|retired>
* Issues: <tbd>
* Installed by package: `libdbusmenu`

### libdbusmenu-qt5

```
/usr/local/lib/libdbusmenu-qt5.so
/usr/local/lib/libdbusmenu-qt5.so.2
/usr/local/lib/libdbusmenu-qt5.so.2.6.0
```

* Author: <tbd>
* Description: Qt5 implementation of the DBusMenu protocol
* Bugtracker: https://launchpad.net/libdbusmenu-qt
* Purpose: <tbd>
* Theory of operation: <tbd>
* Status: active
* Issues: <tbd>
* Installed by package: `libdbusmenu-qt`

### Kf5 Appmenu Plugin

```
/usr/local/lib/qt5/plugins/kf5/kded/appmenu.so
```

* Author: <tbd>
* Description: <tbd>
* Bugtracker: <tbd>
* Purpose: <tbd>
* Theory of operation: <tbd>
* Status: <active|retired>
* Issues: <tbd>
* Installed by package: `<tbd>`

### Kf5 Plasma Applet Appmenu Plugin

```
/usr/local/lib/qt5/plugins/plasma/applets/plasma_applet_appmenu.so
```

* Author: <tbd>
* Description: <tbd>
* Bugtracker: <tbd>
* Purpose: <tbd>
* Theory of operation: <tbd>
* Status: <active|retired>
* Issues: <tbd>
* Installed by package: `<tbd>`

### Kf5 Plasma Private libappmenuplugin

```
/usr/local/lib/qt5/qml/org/kde/plasma/private/appmenu/libappmenuplugin.so
```

* Author: <tbd>
* Description: <tbd>
* Bugtracker: <tbd>
* Purpose: <tbd>
* Theory of operation: <tbd>
* Status: <active|retired>
* Issues: <tbd>
* Installed by package: `<tbd>`

## Executables involved

### GMenu-DBusMenu-Proxy

```
/usr/local/bin/gmenudbusmenuproxy 
```

* Author: Kai Uwe Broulik (KDE)
* Description: <tbd>
* Bugtracker: https://phabricator.kde.org/D10461
* Purpose: <tbd>. Translate between the org.gtk.Menus interface used by Gtk applications and what is needed to satisfy the KDE global menu bar? (Why does KDE need something special?)
* Theory of operation: This application finds windows using GTK GMenu DBus interfaces and forwards them through DBusMenu. (...) LibreOffice with appmenu-gtk-module (...) Works with Gimp or Inkscape if you have appmenu-gtk-module (there's GTK2 and GTK3 variants) installed and GTK_MODULES=appmenu-gtk-module environment variable set. ([Source](https://phabricator.kde.org/transactions/detail/PHID-XACT-DREV-jz6tqizldlvwmv6/))
* Status: <active|retired>
* Issues: Can we get it "standalone", without KDE Plasma?
* Installed by package: `plasma5-plasma-workspace`
