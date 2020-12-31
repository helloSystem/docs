# Global Menu

helloSystem intends to provide a unified user experience for all applications regardless of toolkit being used by application developers.

To provide this unified user experience, it is crucial that all applications can show their commands in the system-wide global menu.

## Terminology

``` .. note::
Consistent, up-to-date documentation reagarding the subject of global menus is hard to find. 

Please consider submitting issues and pull requests if you can contribute to this subject.
```

### Concepts 

* __Global menubar__: A concept in user interface design where a system-wide widget on the screen displays the menu items (also known as "actions" in Qt) for all applications
* __Menu__: The application in helloSystem that shows the global menubar
* [__Status Menu__](https://wiki.ubuntu.com/CustomStatusMenuDesignGuidelines): The term used by Canonical to describe the icons in the upper-right corner of the screen that are usually used for long-running background processes
* [__System Tray__ = __Notification Area__](https://en.wikipedia.org/wiki/Notification_area): The term that describes the icons on the bottom-right corner of the screen on Windows
* [__Application (Panel) Indicators__](https://wiki.ubuntu.com/DesktopExperienceTeam/ApplicationIndicators): Another term used by Canonical to describe __Status Menus__?
* [__Application Menu or appmenu__]: ?

### Implementations

Those may or may not be used in helloSystem, they are mentioned here to give an overview over the field so that technical discussions can be had.

* __Panel__: Ubuntu calls the widget at the top of the screen the "panel". In helloSystem, the rough equivalent is __Menu__.
* [__Aytana__](https://wiki.ubuntu.com/Ayatana): The Buddhist term for a "sense base" or "sense sphere". A project by Canonical to improve user experience in Ubuntu. Abandoned?
* [__Application Menu or appmenu__](https://wiki.ubuntu.com/DesktopExperienceTeam/ApplicationMenu): As part of Aytana, Canonical has produced an implementation called `indicator-appmenu` which re-routes Gtk and Qt menus over `dbusmenu` so that they appear in the panel
* [__dbusmenu__](https://wiki.ubuntu.com/DesktopExperienceTeam/ApplicationIndicators#Software_Architecture): Library by Canonical implementing the transport protocol between the applications and the panel
* [__libappindicator__](https://wiki.ubuntu.com/DesktopExperienceTeam/ApplicationIndicators#Software_Architecture): Library by Canonical to register icons and menus and internally uses dbusmenu to publish context menus over dbus

## Libraries involved

The following libraries are involved in allowing applications to show their menu items in the global menu:

```
/usr/local/lib/gtk-2.0/modules/libappmenu-gtk-module.so
/usr/local/lib/gtk-3.0/modules/libappmenu-gtk-module.so
/usr/local/lib/libappmenu-gtk2-parser.so
/usr/local/lib/libappmenu-gtk2-parser.so.0
/usr/local/lib/libappmenu-gtk3-parser.so
/usr/local/lib/libappmenu-gtk3-parser.so.0
/usr/local/lib/libdbusmenu-glib.so
/usr/local/lib/libdbusmenu-glib.so.4
/usr/local/lib/libdbusmenu-glib.so.4.0.12
/usr/local/lib/libdbusmenu-gtk3.so
/usr/local/lib/libdbusmenu-gtk3.so.4
/usr/local/lib/libdbusmenu-gtk3.so.4.0.12
/usr/local/lib/libdbusmenu-qt5.so
/usr/local/lib/libdbusmenu-qt5.so.2
/usr/local/lib/libdbusmenu-qt5.so.2.6.0
/usr/local/lib/qt5/plugins/kf5/kded/appmenu.so
/usr/local/lib/qt5/plugins/plasma/applets/plasma_applet_appmenu.so
/usr/local/lib/qt5/qml/org/kde/plasma/private/appmenu/libappmenuplugin.so
```
