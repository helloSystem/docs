# Architecture

helloSystem is designed with simplicity in mind. Less, but better. This page describes key elements of the hello desktop. As a general rule, everything should be welcoming for Mac users but 10x as simple.

## Frameworks

In order of preference:
* PyQt
* Qml
* Qt
* Kf5 components where absolutely needed
* Everything else
* Gtk

Rationale: Most cross real-world productivity applications are written cross-platform and this often means Qt. Hence, to provide the best possible environment for those applications, we choose Qt for now. Philosophically, we would prefer to use something BSD licensed (or similar), such as FyneDesk, but in its current state it cannot yet provide the same truly native experience for existing Qt applications. (Maybe it helps to think of Qt as the "Carbon of hello", whereas something else will eventually become the "Cocoa of hello".)

## Desktop components

The minimum number of components viable to produce an efficient desktop should be used. Each component should be as simple as possible, and have as few dependencies as possible (besides the ones that are central to the hello Desktop, such as Qt and PyQt). Outside dependencies that are closely tied to other outside components should be avoided. XDG specifications are considered overly complex but insufficient and should be avoided, but may be acceptable as legacy technology for compatibility reasons.

### Filer

File manager that can handle (simplified) `.app` and `.AppDir` bundles

### Menu

Global menu bar that displays the System menu for system-wide commands (such as 'About this Computer'), and the active application's menus. It also contains a search box to search in the menus.

### Dock

A Dock that shows icons for running and pinned applications. (In the future it should als get an animated icon as a launching indicator for applications that are being launched but are not yet showing a window.)

### `launch` command

The `launch` command is used to launch applications without specifying a path to them.

The `launch` command is expceted to determine the preferred instance of an application with the given name. (The `launch` command is supposed to find the _preferred_ instance, e.g., the one with the highest version, the one last put onto the system, etc.) Eventually the `launch` command should also get knowledge which application to open a file with.

Filer is supposed to launch all applications through the `launch` command. Shell scripts, `.desktop` files, etc. should be written to use the `launch` command rather than hardcoding paths to applications, where appropriate.

If an application cannot be launched, the `launch` command shall give a localized, understandable clear-text error message and offer a solution if possible; fall back to the console output of the application that could not be launched.
When beginning to launch an application, the `launch` command shall notify the Dock via some IPC mechanism (ideally something _much_ simpler than the convoluted D-Bus) about the icon and name of the application about to be launched, so that the Dock can start a launch animation until the application is showing its first window).

### IPC mechanism for the desktop

A very simple IPC mechanism should be introduced for the desktop components to talk to each other. A lightweight, standard publish/subscribe mechanism should be identified; _possibly_ something like MQTT (which would have the added benefit of allowing for network-wide communication). In the meantime, the use of D-Bus as a legacy technology may be acceptable (even though it is considered obscure, convoluted, and closely linked with various other Red Hat technologies.)

### Applications

Applications must not need to be installed. Simply downloading them, attaching an external drive containing them, or connecting to a network share containing them must be sufficient. Mutliple versions of the same application must be able to co-exist. The `launch` command is resposible to determine which one to use in cases where the user did not explicitly launch a specific instance by double-clicking it.

Custom-written applications should come as Appplication bundles whenever possible. It is accaptable for pre-existing applications to come with legacy XDG desktop files instead.

### Utilities

The system should come with some commonly used utilities, such as a Terminal application, a Process Monitor application, etc. These are just regular applications inside a 'Utilities' subdirectory. It is accaptable for pre-existing applications, preferably written in Qt.

### Preferences

The system should come with some commonly used preference panels, such as for configuring the system language, OpenZFS Boot Environments, etc. These are just regular applications inside a 'Preferences' subdirectory. These should be super simple, "minimal viable" applications. It is expected that many will need to be written from scratch, but it is accaptable to re-use pre-existing applications, preferably written in Qt.
