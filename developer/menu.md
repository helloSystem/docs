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

### Implementations

Those may or may not be used in helloSystem, they are mentioned here to give an overview over the field so that technical discussions can be had.

* __Panel__: Ubuntu calls the widget at the top of the screen the "panel". In helloSystem, the rough equivalent is __Menu__.
* [__Aytana__](https://wiki.ubuntu.com/Ayatana): The Buddhist term for a "sense base" or "sense sphere". A project by Canonical to improve user experience in Ubuntu. Abandoned?
* [__Application Menu or appmenu__](https://wiki.ubuntu.com/DesktopExperienceTeam/ApplicationMenu): As part of Aytana, Canonical has produced an implementation called `indicator-appmenu` which re-routes Gtk and Qt menus over `dbusmenu` so that they appear in the panel
* [__dbusmenu__](https://wiki.ubuntu.com/DesktopExperienceTeam/ApplicationIndicators#Software_Architecture): Library by Canonical implementing the transport protocol between the applications and the panel
* [__libappindicator__](https://wiki.ubuntu.com/DesktopExperienceTeam/ApplicationIndicators#Software_Architecture): Library by Canonical to register icons and menus and internally uses dbusmenu to publish context menus over dbus. The same as [`indicator-application`](https://launchpad.net/indicator-application)?
* [__MenuModel__](): Used by Gtk

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
* Status: <active|retired>
* Issues: Supposedly used by Firefox and Chrome but those applications are not functional with Menu in helloSystem yet
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
* Issues: <tbd>
* Installed by package: In Ubuntu, `sudo apt-get install unity-gtk-module-common unity-gtk2-module unity-gtk3-module`
    
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
* Description: <tbd>
* Bugtracker: <tbd>
* Purpose: <tbd>
* Theory of operation: <tbd>
* Status: <active|retired>
* Issues: <tbd>
* Installed by package: `<tbd>`

### libdbusmenu-gtk3

```
/usr/local/lib/libdbusmenu-gtk3.so
/usr/local/lib/libdbusmenu-gtk3.so.4
/usr/local/lib/libdbusmenu-gtk3.so.4.0.12
```

* Author: <tbd>
* Description: <tbd>
* Bugtracker: <tbd>
* Purpose: <tbd>
* Theory of operation: <tbd>
* Status: <active|retired>
* Issues: <tbd>
* Installed by package: `<tbd>`

### libdbusmenu-qt5

```
/usr/local/lib/libdbusmenu-qt5.so
/usr/local/lib/libdbusmenu-qt5.so.2
/usr/local/lib/libdbusmenu-qt5.so.2.6.0
```

* Author: <tbd>
* Description: <tbd>
* Bugtracker: <tbd>
* Purpose: <tbd>
* Theory of operation: <tbd>
* Status: <active|retired>
* Issues: <tbd>
* Installed by package: `<tbd>`

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
