# Extending Filer context menus

It is possible to extend Filer context menu items by writing files that conform to the __DES-EMA__ (Desktop Entry Specification - Extension for Menus and Actions). Apparently this format was never adopted as a standard, so it is documented here. The information on this page is based on [draft 0.15](https://gitlab.gnome.org/GNOME/filemanager-actions/-/blob/NAUTILUS_ACTIONS_3_2_4/docs/des-ema/des-ema-0.15) from November 23, 2010.

``` .. note::
    Filer inherits its DES-EMA implementation from PCManFM, but may use a different format in the future.
    
    It still needs to be verified which portions have actually been implemented in Filer, so currently this page describes functionality which may or may not be implemented in Filer. Corrections are welcome.
```

Changes take effect after a restart of Filer. To restart Filer:
1. Press Ctrl+Alt+Esc and click on the Desktop to force-quit it
2. Press Alt+F2 and enter `launch Filer --desktop` to start it again

## Examples

### An example of an action

In the following example, we define an "Open terminal here" action, which has three profiles. These profiles are thought to be able to open a suitable terminal in most situations. They are ordered, and so only the first profile whose conditions are met at runtime will be used in the Filer context menu.

```
[Desktop Entry]
Name=Open terminal here
Tooltip=Open a new terminal here
Icon=terminal
Profiles=on_folder; on_file; on_desktop;

[X-Action-Profile on_folder]
Name=open a terminal on the current folder or on the selected folder
MimeTypes=inode/directory;
# note that this means strictly less than 2, as the equal sign is part of the DES syntax
SelectionCount=< 2
Exec=launch QTerminal --workdir %d

[X-Action-Profile on_file]
Name=open a terminal in the folder which contains selected items
MimeTypes=all/allfiles;
Exec=launch QTerminal --workdir $(echo %D | cut -d ' ' -f 1)

[X-Action-Profile on_desktop]
Name=open a terminal of the desktop
Schemes=x-nautilus-desktop;
Exec=launch QTerminal --workdir ~/Desktop
```

This may be saved, e.g. as `~/.local/share/file-manager/actions/open-terminal.desktop` file.

Note that this is only an example of how an action may be defined in a `.desktop` file. It has not been deeply tested, and there is most probably more efficient ways of opening a terminal somewhere...

### An example of a menu

Suppose we would like to place the menu elements into a submenu. To achieve this, we create a second `.desktop` file with following content:

```
[Desktop Entry]
Type=Menu
Name=Terminal menu
Tooltip=Terminal submenu
Icon=terminal-group
ItemsList=open-terminal;
```

This may be saved, e.g. as `~/.local/share/file-manager/actions/menu-terminal.desktop` file.

## Desktop file

#### Desktop file format

This specification relies on the common syntax defined in the [Desktop Entry Specification](http://standards.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html). Here is a summary of some main points:

*   Files are UTF-8 encoded.
*   All keys and values are case sensitive.
*   The `[Desktop Entry]` group must be the first group of the file.
*   Boolean values must be `true` or `false`.
*   Strings, in strings lists, are semicolon-separated; the list itself ends with a semicolon.

#### Desktop file identifier

In the rest of this specification, when a desktop file needs to be identified, we are using the basename of the file, without the extension, calling this a _desktop_file_id_.

#### Desktop files search path

`.desktop` files are searched for in `XDG_DATA_DIRS/file-manager/actions` directories. All used _desktop_file_id_s should be unique.

## Managed objects

#### Actions and profiles

This specification essentially defines how actions are to be described in `.desktop` files in order to be displayed in the Filer context menu, and available as selectable items to be executed by the user.

An action might be defined as a group of several elements:

* the displayable part: label, tooltip, icon
* conditions which have to be met in order the item be actually displayed in the context menu; these conditions are checked against the current Filer selection; these might be mimetypes, scheme, etc.
* the command to be executed, and its parameters.

As a user might want have the very same action execute a different command depending of the current environment at runtime, we define that an action is built on one to several profiles, where each profile is defined by:

* conditions which have to be met in order the item be actually displayed in the context menu; these conditions are checked against the current Filer selection; these might be mimetypes, scheme, etc.
* the command to be executed, and its parameters.

#### Menus

This specification also defines how these actions may be gathered and ordered in menus, and submenus, and so on.

A menu is defined by:

* its displayable part: label, tooltip, icon
* conditions which are to be met in order the menu, and recursively all of its subitems, be actually displayed in the Filer context menu
* the ordered list of the items in the menu.

#### Conditions

As we are dealing with three level of objects (menus, actions, profiles), it appears that whether a condition must be defined at one of these levels is rather an arbitrary decision.

We so say that conditions may appear in any of these levels:

* When a condition appears in a menu definition, the result of its evaluation recursively applies to all included items. If the condition is not met, then neither the menu nor any of its subitems will be displayed.
* When a condition appears in an action definition, the result of its evaluation applies to all its profiles. If the condition is not met, then the action will not be candidate; the profiles will even not be considered.

## Action definition

An action must be entirely defined in one `.desktop` file. The action is identified by the _desktop_file_id_ in which it is defined.

Only valid actions are displayed in the Filer context menu.

To be valid, an action must have a non-empty name, and at least one profile must be found valid at runtime.

As stated

An action is primarily defined in the `[Desktop Entry]` group, which has following keys:

<table border="1">

<tbody>

<tr valign="top">

<td>**Key**</td>

<td>**Description**</td>

<td nowrap="nowrap">**Value type**</td>

<td>**Req ?**</td>

</tr>

<tr valign="top">

<td>`Type`</td>

<td>This define this `.desktop` file as an Action definition.  
Defaults to `Action`.</td>

<td>string</td>

<td>no</td>

</tr>

<tr valign="top">

<td>`Name`</td>

<td>The label of the action, as it should appear in the context menu.  
</td>

<td>localestring</td>

<td>YES</td>

</tr>

<tr valign="top">

<td>`Tooltip`</td>

<td>The tooltip associated with the item in the context menu.  
Defaults to empty.</td>

<td>localestring</td>

<td>no</td>

</tr>

<tr valign="top">

<td>`Icon`</td>

<td>The name of a themed icon, or the path to an icon.  
Defaults to empty.</td>

<td>localestring</td>

<td>no</td>

</tr>

<tr valign="top">

<td>`Description`</td>

<td>A free description of the action, which may be used in the management UI, in a Web page, and so on.  
Defaults to empty.</td>

<td>localestring</td>

<td>no</td>

</tr>

<tr valign="top">

<td>`SuggestedShortcut`</td>

<td>A shortcut suggested for the action.  
Please note that this might be only a suggestion as the shortcut may be already reserved for another use. Implementation should not override an already existing shortcut to define this one.  
The format may look like `<Control>a` or `<Shift><Alt>F1`.  
Defaults to empty.</td>

<td>string</td>

<td>no</td>

</tr>

<tr valign="top">

<td>`Enabled`</td>

<td>Whether the item is candidate to be displayed in the context menu.  
A user might define many actions or menus, and choose to only enable some of them from time to time.  
Defaults to `true`.</td>

<td>boolean</td>

<td>no</td>

</tr>

<tr valign="top">

<td>`Hidden`</td>

<td>From [DES](http://standards.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html): `Hidden` should have been called `Deleted`. It means the user deleted (at his level) something that was present (at an upper level, e.g. in the system dirs). It's strictly equivalent to the `.desktop` file not existing at all, as far as that user is concerned. This can also be used to "uninstall" existing files (e.g. due to a renaming) - by letting make install install a file with `Hidden=true` in it.  
Defaults to `false`.</td>

<td>boolean</td>

<td>no</td>

</tr>

<tr valign="top">

<td>`TargetContext`</td>

<td>Whether the item targets the Filer context menu.  
This means that the action will be candidate if defined conditions met the current selection.  
Defaults to `true`.</td>

<td>boolean</td>

<td>no</td>

</tr>

<tr valign="top">

<td>`TargetLocation`</td>

<td>Whether the item targets a location menu, if Filer supports this.  
This means that the action will be candidate if defined conditions met the current location.  
Defaults to `false`.</td>

<td>boolean</td>

<td>no</td>

</tr>

<tr valign="top">

<td>`TargetToolbar`</td>

<td>Whether the item targets the toolbar, if Filer supports this.  
Note that, in order to keep a nice and stable UI, the Filer may reserve toolbar actions to those only targeting the current folder.  
Defaults to `false`.</td>

<td>boolean</td>

<td>no</td>

</tr>

<tr valign="top">

<td>`ToolbarLabel`</td>

<td>The label to be displayed in the toolbar, if it is not the same that those displayed in context menu.  
Defaults to `Name` value.</td>

<td>localestring</td>

<td>no</td>

</tr>

<tr valign="top">

<td nowrap="nowrap">`Profiles`</td>

<td>

The ordered list of the profiles attached to this action.  
Each element of this strings list may be:

*   a _profile_id_, _i.e._ the id of a profile, as an ASCII string
*   a command to be executed, if the string is enclosed between square brackets (`[`...`]`).

So, `Profiles` key has a dynamic value: if an element of the string list is enclosed between square brackets (`[`...`]`), it is considered as a command, optionally with

After reading, and maybe evaluation of dynamic elements, profiles identified by the `Profiles` value, but not found in this `.desktop` file, are just ignored.

It is up to the implementation to decide whether profiles found in this `.desktop` file, but not identified in this list, should or not be attached to the action.  
It could be for example an acceptable fallback to append these "orphan" profiles at the end of the list of profiles.  
Another choice might also be:

*   at runtime, only attach to the action profiles which are listed in this `Profiles` key
*   while a management UI may load all profiles found in the `.desktop` file.

</td>

<td>strings list</td>

<td>YES</td>

</tr>

</tbody>

</table>


## Profile definition

Profile is identified by its _profile_id_, as an ASCII string.

Each profile defined in the `Profiles` key, whether statically by its _profile_id_ identifier, or as the result of an evaluated command, must be defined in a `[X-Action-Profile _profile_id_]` group.

When several profiles are defined for an action, only the first valid profile whose conditions are met at runtime is selected to be made available in the context menu.

Defining several profiles let so the user have an ordered OR-ed set of conditions, i.e. have one action be available if one set of conditions is met, OR this same action, though most probably with a slightly different command, be available if another set of conditions is met, and so on.

In order to be valid, a profile must at least have an executable command.

<table border="1">

<tbody>

<tr valign="top">

<td>**Key**</td>

<td>**Description**</td>

<td nowrap="nowrap">**Value type**</td>

<td>**Req ?**</td>

</tr>

<tr valign="top">

<td>`Name`</td>

<td>The name of the profile; this name is not displayed in the context menu, and should just be thought as a convenience for the management UI. It may also be seen as a good place for a description of what the profile exactly does.  
Defaults to empty.</td>

<td>localestring</td>

<td>no</td>

</tr>

<tr valign="top">

<td>`Exec`</td>

<td>From [DES](http://standards.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html): command to execute, possibly with arguments  
</td>

<td>string</td>

<td>YES</td>

</tr>

<tr valign="top">

<td>`Path`</td>

<td>The working directory the program should be started in.  
Defaults to base directory of the current selection, which happens to be the value of `%d` parameter.</td>

<td>string</td>

<td>no</td>

</tr>

<tr valign="top">

<td>`ExecutionMode`</td>

<td>Execution mode of the program.  
This may be chosen between following values:

*   `Normal`: Starts as a standard graphical user interface
*   `Terminal`: Starts the preferred terminal of the graphical environment, and runs the command in it
*   `Embedded`: Makes use of a special feature of the file manager which allows a terminal to be ran inside of it; an acceptable fallback is `Terminal`
*   `DisplayOutput`: The ran terminal may be closed at end of the command, but standard streams (stdout, stderr) should be collected and displayed; an acceptable fallback is `Terminal`

Defaults to `Normal`.</td>

<td>string</td>

<td>no</td>

</tr>

<tr valign="top">

<td>`StartupNotify`</td>

<td>From [DES](http://standards.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html): if `true`, it is KNOWN that the application will send a "remove" message when started with the DESKTOP_STARTUP_ID environment variable set. If `false`, it is KNOWN that the application does not work with startup notification at all (does not shown any window, breaks even when using StartupWMClass, etc.). If absent, a reasonable handling is up to implementations (assuming false, using StartupWMClass, etc.). (See the [Startup Notification Protocol Specification](http://www.freedesktop.org/Standards/startup-notification-spec) for more details).  
Only relevant when `ExecutionMode=Normal`.  
Defaults to `false`.</td>

<td>boolean</td>

<td>no</td>

</tr>

<tr valign="top">

<td>`StartupWMClass`</td>

<td>From [DES](http://standards.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html): if specified, it is known that the application will map at least one window with the given string as its WM class or WM name hint (see the [Startup Notification Protocol Specification](http://www.freedesktop.org/Standards/startup-notification-spec) for more details).  
Only relevant when `ExecutionMode=Normal`.  
Defaults to empty.</td>

<td>string</td>

<td>no</td>

</tr>

<tr valign="top">

<td>`ExecuteAs`</td>

<td>The user the command must be ran as. The user may be identified by its numeric UID or by its login.  
The implementation should ignore a profile defining a non-existing UID or login as a value for the `ExecuteAs` key.  
The implementation might require the presence of a well-configured subsystem (e.g. sudo).  
Defaults to empty: the command will be executed as the current user.</td>

<td>string</td>

<td>no</td>

</tr>

</tbody>

</table>


## Menu definition

Just as an action, a menu has label, tooltip, icon.

But, where an action is intended to eventually execute a command, a menu is just a way of gathering some subitems, actions or menus, in an ordered list.

In order to be valid, a menu must have a non-empty name, and include at least one valid subitem.

It is the responsibility of the implementation to ensure that the displayed menus are relevant, _i.e._ not empty, with no separator at the begin or the end of the menu, with no double separator, etc.

As stated

The menu is so defined as a particular case of a `.desktop` file, identified by its _desktop_file_id_, whose the `[Desktop Entry]` section has following keys:

<table border="1">

<tbody>

<tr valign="top">

<td nowrap="nowrap">**Key**</td>

<td>**Description**</td>

<td nowrap="nowrap">**Value type**</td>

<td>**Req ?**</td>

</tr>

<tr valign="top">

<td>`Type`</td>

<td>This define this `.desktop` file as a Menu definition.  
Must be equal to `Menu`.</td>

<td>string</td>

<td>YES</td>

</tr>

<tr valign="top">

<td>`Name`</td>

<td>The label of the menu, as it should appear in the context menu.  
</td>

<td>localestring</td>

<td>YES</td>

</tr>

<tr valign="top">

<td>`Tooltip`</td>

<td>The tooltip associated with the submenu in the context menu.  
Defaults to empty.</td>

<td>localestring</td>

<td>no</td>

</tr>

<tr valign="top">

<td>`Icon`</td>

<td>The name of a themed icon, or the path to an icon, to be associated to the submenu.  
Defaults to empty.</td>

<td>localestring</td>

<td>no</td>

</tr>

<tr valign="top">

<td>`Description`</td>

<td>A free description of the menu, which may be used in the management UI, in a Web page, and so on.  
Defaults to empty.</td>

<td>localestring</td>

<td>no</td>

</tr>

<tr valign="top">

<td>`SuggestedShortcut`</td>

<td>A shortcut suggested for the menu.  
Please note that this might be only a suggestion as the shortcut may be already reserved for another use. Implementation should not override an already existing shortcut to define this one.  
The format may look like `<Control>a" or `<Shift><Alt>F1".  
Defaults to empty.</td>

<td>string</td>

<td>no</td>

</tr>

<tr valign="top">

<td>`Enabled`</td>

<td>Whether the item is candidate to be displayed in the context menu.  
A user might define many actions or menus, and choose to only enable some of them from time to time.  
Defaults to `true`.</td>

<td>boolean</td>

<td>no</td>

</tr>

<tr valign="top">

<td>`Hidden`</td>

<td>From [DES](http://standards.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html): `Hidden` should have been called `Deleted`. It means the user deleted (at his level) something that was present (at an upper level, e.g. in the system dirs). It's strictly equivalent to the `.desktop` file not existing at all, as far as that user is concerned. This can also be used to "uninstall" existing files (e.g. due to a renaming) - by letting make install install a file with `Hidden=true` in it.  
Defaults to `false`.</td>

<td>boolean</td>

<td>no</td>

</tr>

<tr valign="top">

<td nowrap="nowrap" id="itemslist">`ItemsList`</td>

<td>

The ordered list of the subitems (actions or menus) attached to this menu.  
Each element of this strings list may be:

*   the id of an action or a menu,
*   a command to be executed, if the string is enclosed between square brackets (`[`...`]`).

So, `ItemsList` key has a dynamic value: if an element of the string list is enclosed between square brackets (`[`...`]`), it is considered as a command, optionally with

The keyword `SEPARATOR` is a special case of _desktop_file_id_. It may be used to define a separator in the menu.

Actions or menus identified here as a subitem of a menu should not be redisplayed elsewhere.

Actions or menus not identified here, or not identified as subitems of a menu or of a submenu, should not be ignored by the implementation; instead of that, the implementation should display these "orphan" items, most probably at the level zero of the hierarchy (though in a unspecified order).

</td>

<td>strings list</td>

<td>YES</td>

</tr>

</tbody>

</table>


## Conditions

As a remainder of that has been said above, each one of the following conditions may appear in a menu, an action or a profile.

Conditions are AND-ed, that is all specified conditions which appear in a menu, an action or a profile must be met in order the item be considered as a candidate.

When a condition is defined as a string list, elements of the list are considered as OR-ed (but for When an element of the string list is negated, it must be considered as an AND condition.

Example:

> The line "`MimeTypes = image/*; video/*;`" must be read as "condition is met if each file in the current selection has a mimetype of `image/*` or of `video/*`"
> 
> And the line "`MimeTypes = image/*; video/*; !image/bmp`" must be read as "condition is met if each file in the current selection has a mimetype of `image/*` or of `video/*`, but must not have the `image/bmp` mimetype".

<table border="1">

<tbody>

<tr valign="top">

<td>**Key**</td>

<td>**Description**</td>

<td nowrap="nowrap">**Value type**</td>

<td>**Req ?**</td>

</tr>

<tr valign="top">

<td>`OnlyShowIn`,  
`NotShowIn`</td>

<td>From [DES](http://standards.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html): a list of strings identifying the environments that should display/not display a given desktop entry. Only one of these keys, either `OnlyShowIn` or `NotShowIn`, may appear in a group (for possible values see the [Desktop Menu Specification](http://www.freedesktop.org/Standards/menu-spec)).  
Defaults to show anywhere.</td>

<td nowrap="nowrap">strings list</td>

<td>no</td>

</tr>

<tr valign="top">

<td>`TryExec`</td>

<td>From [DES](http://standards.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html): path to an executable file on disk used to determine if some program is actually installed. If the path is not an absolute path, the file is looked up in the $PATH environment variable. If the file is not found or is not executable, this condition evals to `false`.  
Defaults to successful.</td>

<td>string</td>

<td>no</td>

</tr>

<tr valign="top">

<td>`ShowIfRegistered`</td>

<td>The well-known name of a DBus service.  
The item will be candidate if the named service is registered on session DBus at runtime.  
Defaults to successful.  

<table border="0">

<tbody>

<tr>

<td valign="top">_Comment:_</td>

<td valign="top">_This is the equivalent of KDE `X-KDE-ShowIfRunning` key._</td>

</tr>

</tbody>

</table>

</td>

<td>string</td>

<td>no</td>

</tr>

<tr valign="top">

<td>`ShowIfTrue`</td>

<td>A command which, when executed, should output a string on stdout.  
The item will be candidate if the outputted string is equal to `true`.  
Example: `[ -r %d/.svn/entries ] && echo \"true\`  
Defaults to successful.  

<table border="0">

<tbody>

<tr>

<td valign="top">_Comment:_</td>

<td valign="top">_This is the equivalent of KDE `X-KDE-ShowIfDBusCall` key, extended to any command able to output a string._</td>

</tr>

</tbody>

</table>

</td>

<td>string</td>

<td>no</td>

</tr>

<tr valign="top">

<td>`ShowIfRunning`</td>

<td>The name of a process.  
The item will be candidate if the process name is found in memory at runtime.  
Defaults to successful.</td>

<td>string</td>

<td>no</td>

</tr>

<tr valign="top">

<td>`MimeTypes`</td>

<td>From [DES](http://standards.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html): the MIME type(s) supported by this application.  
Each mimetype may be fully specified (e.g. `audio/mpeg;`), or as a group (e.g. `image/*;`).  
Mimetypes may be negated (e.g. `audio/*; !audio/mpeg;`).  
Some of well-known mimetypes include:  

*   `all/all`: matches all items
*   `all/allfiles`: matches only files
*   `inode/directory`: matches only directories

`*` character is accepted as a wildcard in only two cases:

*   when used alone as in `*;`, _i.e._ when used as a group wildcard without subgroup,
*   when used as the subgroup wildcard, after the `/` character, as in `image/*`.

Defaults to `*;`, which happens to be exactly equivalent to `all/all` or to `all/*`.

<table border="0">

<tbody>

<tr>

<td valign="top">_Comment:_</td>

<td></td>

<td>_This is the equivalent of `ServiceTypes`, `X-KDE-ServiceTypes`, `ExcludeServiceTypes` KDE and `MimeType` freedesktop keys._</td>

</tr>

</tbody>

</table>

</td>

<td>strings list</td>

<td>no</td>

</tr>

<tr valign="top">

<td>`Basenames`</td>

<td>List of basenames the selection should match in order this profile be selected.  
`*` character is accepted as a wildcard.  
Basenames may be negated (e.g. `*; !*.h;`).  
Defaults to `*;`.</td>

<td>strings list</td>

<td>no</td>

</tr>

<tr valign="top">

<td>`Matchcase`</td>

<td>Whether the above `Basenames` is case sensitive.  
Defaults to `true`.</td>

<td>boolean</td>

<td>no</td>

</tr>

<tr valign="top">

<td id="selection-count">`SelectionCount`</td>

<td>Whether this profile may be selected depending of the count of the selection.  
This is a string of the form `{'<'|'='|'>'} number`.  
Examples of valid strings are: `=0`, `> 1`, `< 10`.  
Defaults to `>0`.</td>

<td>string</td>

<td>no</td>

</tr>

<tr valign="top">

<td>`Schemes`</td>

<td>The list of schemes the selection must satisfy in order the item be selected.  
Examples of well-known schemes are:  

*   `file`
*   `sftp`
*   `smb`
*   `http`

Schemes may be negated, e.g. `!http;`.  
Defaults to `*;`.

<table border="0">

<tbody>

<tr>

<td valign="top">_Comment:_</td>

<td valign="top">_This is the equivalent of `X-KDE-Protocol` and `X-KDE-Protocols` KDE keys._</td>

</tr>

</tbody>

</table>

</td>

<td>strings list</td>

<td>no</td>

</tr>

<tr valign="top">

<td>`Folders`</td>

<td>A list of paths the current base directory must be in in order the item be selected.  
A folder path may be negated (e.g. `/data; !/data/resources/secret;`).  
`*` character is accepted as a wildcard, replacing any level(s) of subdirectory (e.g. `/music; /video; !*/secret;`).  
Also note that a terminating `/*` is always implied by the definition of this key.  
Last, note that different implementations today widely consider that, for a directory point of view, having no selection is roughly the same that selecting the currently opened folder. If this makes a difference for your action, then</td>

<td>strings list</td>

<td>no</td>

</tr>

<tr valign="top">

<td id="capabilities">`Capabilities`</td>

<td>A list of capabilities each item of the selection must satisfy in order the item be candidate.  
Capabilities may be negated.  
Please note that each element of the specified list must be considered as ANDed, i.e. if we have `Capabilities=Readable;Writable;!Local`, then each element of the selection must be both readable AND writable AND not local.  
Capabilities have to be chosen between following predefined ones:

*   `Owner`: current user is the owner of the selected items
*   `Readable`: selected items are readable by user (probably more useful when negated)
*   `Writable`: selected items are writable by user
*   `Executable`: selected items are executable by user
*   `Local`: selected items are local

Defaults to an empty list (do not care of capabilities).

<table border="0">

<tbody>

<tr>

<td valign="top">_Comment:_</td>

<td valign="top">_This is the equivalent of `X-KDE-Require` KDE key._</td>

</tr>

</tbody>

</table>

</td>

<td>strings list</td>

<td>no</td>

</tr>

</tbody>

</table>


## Parameters

### Parameters expansion

Whenever parameters are said to be accepted, they will be replaced at run-time.

It should be noted by the implementation that items, actions or menus, which were considered valid at load time, may become invalid after parameters expansion, due, for example, to a label becoming empty.

Also, this specification doesn't make any assumption about whether a parameter is relevant in a given situation, or secure, or may be used several times, or so. It instead considers that this sort of check is up to the action creator.

The implementation should take care of correctly shell-escape the substituted values, so that it should not be needed for the action creator to use any sort of quotes to handle spaces in filenames.

### Multiple execution

The action creator may want its command be executed once, giving it the list of selected items as argument.

Or the action creator may want its command be repeated for each selected item, giving to each execution a different item as argument.

Actually, the command defined in the `Exec` key will be executed once, or repeated for each selected item, depending of the form of arguments.

Though some parameters are not sensible to the count of the selection (e.g. `%c`, the selection count itself), most have two declensions:

*   a "singular" one, e.g. `%b`, the basename of the selected item
*   a "plural" one, e.g. `%B`, a space-separated list of the basenames of selected items

When the selection is empty or contains only one element, and from this topic point of view, these two forms are exactly equivalent.

When the selection contains more than one item:

*   if the first relevant parameter found in the `Exec` key is of a singular form, then the implementation should consider that the command is only able to deal with one item at a time, and thus that it has to be ran one time for each selected item;
*   contrarily, if the first relevant parameter found is of the plural form, then the implementation should consider that the command is able to deal with a list of items, and thus the command should be executed only once;
*   if all found parameters are "irrelevant", then the default is to consider that the command should be executed only once.

Example:

> Say the current folder is /data, and the current selection contains the three files `pierre`, `paul` and `jacques`.
> 
> If the `Exec` key is `echo %b`, then the following commands will be run:  
> `echo pierre`  
> `echo paul`  
> `echo jacques`  
> 
> If the `Exec` key is `echo %B`, then the following command will be run:  
> `echo pierre paul jacques`
> 
> If the `Exec` key is `echo %b %B`, then the following commands will be run:  
> `echo pierre pierre paul jacques`  
> `echo paul pierre paul jacques`  
> `echo jacques pierre paul jacques`  
> 
> If the `Exec` key is `echo %B %b`, then the following commands will be run:  
> `echo pierre paul jacques pierre`  
> The basename used is the one of the first item of the selected items list as provided by the Filer. There is only a small chance that it would be those of the first visually selected item, and there is contrarily great chances that it would not be predictable at all.
> 
> Even if the chosen parameter is the same for all selected items, the behavior is identical.  
> If the `Exec` key is `echo %d %B`, then the following commands will be run:  
> `echo /data pierre paul jacques`  
> `echo /data pierre paul jacques`  
> `echo /data pierre paul jacques`  
> which obviously doesn't make many sense.
> 
> As the last three examples show up, action creator should avoid to mix singular and plural forms, unless they know what they are doing, whether it doesn't make sense or this may lead to unwaited results.
> 
> Nonetheless, mixing singular and plural forms, though we warn against, is not an error. As a counter example, there may be some situations where a command-line of the form `echo %B %d` would be useful. In that case, the following command would be run:  
> `echo pierre paul jacques /data`  
> It is left as an exercise for the reader to find a use case.

The word "first" in the following table makes so reference to the case where the singular form parameter is used in a plural form command. We recall one more time that which is the "first" element is not specified, and, most probably, rather unpredictable.

<table border="1">

<tbody>

<tr valign="top">

<td align="center">**Parameter**</td>

<td>**Description**</td>

<td colspan="3" align="center">**Said form**</td>

</tr>

<tr valign="top">

<td align="center">%b</td>

<td>(first) basename</td>

<td>singular</td>

<td></td>

<td></td>

</tr>

<tr valign="top">

<td align="center">%B</td>

<td>space-separated list of basenames</td>

<td></td>

<td></td>

<td>plural</td>

</tr>

<tr valign="top">

<td align="center">%c</td>

<td>count of selected items</td>

<td></td>

<td>irrelevant</td>

<td></td>

</tr>

<tr valign="top">

<td align="center">%d</td>

<td>(first) base directory</td>

<td>singular</td>

<td></td>

<td></td>

</tr>

<tr valign="top">

<td align="center">%D</td>

<td>space-separated list of base directory of each selected items</td>

<td></td>

<td></td>

<td>plural</td>

</tr>

<tr valign="top">

<td align="center">%f</td>

<td>(first) file name</td>

<td>singular</td>

<td></td>

<td></td>

</tr>

<tr valign="top">

<td align="center">%F</td>

<td>space-separated list of selected file names</td>

<td></td>

<td></td>

<td>plural</td>

</tr>

<tr valign="top">

<td align="center">%h</td>

<td>hostname of the (first) URI</td>

<td></td>

<td>irrelevant</td>

<td></td>

</tr>

<tr valign="top">

<td align="center">%m</td>

<td>mimetype of the (first) selected item</td>

<td>singular</td>

<td></td>

<td></td>

</tr>

<tr valign="top">

<td align="center">%M</td>

<td>space-separated list of the mimetypes of the selected items</td>

<td></td>

<td></td>

<td>plural</td>

</tr>

<tr valign="top">

<td align="center">%n</td>

<td>username of the (first) URI</td>

<td></td>

<td>irrelevant</td>

<td></td>

</tr>

<tr valign="top">

<td align="center">%o</td>

<td>no-op operator which forces a singular form of execution when specified as first parameter,  
ignored else</td>

<td>singular</td>

<td></td>

<td></td>

</tr>

<tr valign="top">

<td align="center">%O</td>

<td>no-op operator which forces a plural form of execution when specified as first parameter,  
ignored else</td>

<td></td>

<td></td>

<td>plural</td>

</tr>

<tr valign="top">

<td align="center">%p</td>

<td>port number of the (first) URI</td>

<td></td>

<td>irrelevant</td>

<td></td>

</tr>

<tr valign="top">

<td align="center">%s</td>

<td>scheme of the (first) URI</td>

<td></td>

<td>irrelevant</td>

<td></td>

</tr>

<tr valign="top">

<td align="center">%u</td>

<td>(first) URI</td>

<td>singular</td>

<td></td>

<td></td>

</tr>

<tr valign="top">

<td align="center">%U</td>

<td>space-separated list of selected URIs</td>

<td></td>

<td></td>

<td>plural</td>

</tr>

<tr valign="top">

<td align="center">%w</td>

<td>(first) basename without the extension</td>

<td>singular</td>

<td></td>

<td></td>

</tr>

<tr valign="top">

<td align="center">%W</td>

<td>space-separated list of basenames without their extension</td>

<td></td>

<td></td>

<td>plural</td>

</tr>

<tr valign="top">

<td align="center">%x</td>

<td>(first) extension</td>

<td>singular</td>

<td></td>

<td></td>

</tr>

<tr valign="top">

<td align="center">%X</td>

<td>space-separated list of extensions</td>

<td></td>

<td></td>

<td>plural</td>

</tr>

<tr valign="top">

<td align="center">%%</td>

<td>the "%" character</td>

<td></td>

<td>irrelevant</td>

<td></td>

</tr>

</tbody>

</table>


## Building the whole hierarchy

The processus described here is only a sort of meta-algorithm, whose only goal is to better specify how the menus and actions should be laid out in the final hierarchy.

The implementer might take advantage of preparing once the whole hierarchy of the menus and actions:

*   to minimize the time spent in the parsing of all files;
*   to identify and eliminate duplicate _desktop_file_id_s,
*   to eliminate invalid menus and actions.

1.  as described in desktop_file_ids and invalid `.desktop` files; implementation so obtains a flat list of menus or actions;  

2.  recursively build the hierarchy; this merely consists in the build of the hierarchy as a tree of menus and actions, where each _desktop_file_id_ addressed as the subitem of a menu consumes this same id from the flat list
    *   if the level-zero order (which is not specified here, but see desktop_file_id addressed in the level zero consumes this same id from the flat list;
    *   else, if might be reasonable to start with an empty tree;  

3.  at the end, implementation stays with:
    *   the output tree with some menus at the root;
    *   some actions, left in the input flat list because they were not addressed by any menu; these left actions should be added to the level zero of the hierarchy (though in a unspecified order)
    *   some menus, left in the input flat list because their subitems were not found; as these menus happen to be empty, they must be considered as invalid.

After this built phase, the resultant tree only contains valid (before runtime parameters expansion) menus and actions.

So, menus or actions may appear at the level zero of the whole hierarchy for only two reasons:

1.  because they are explicitly addressed by the level-zero configuration, if the implementation defines it; this may concern menus and actions;
2.  because these items were not addressed by any menu (but this may only concern actions).

## The level-zero case

Though not strictly an action or a menu definition, the level-zero issue might be easily solved by this specification. The implementation is free to implement it or not.

Ordering the elements which have to be displayed at the level-zero of the Filer context menu is just a particular case of a menu definition.

An implementation might define a `level-zero.directory` file, which would contain the ordered list of level zero items identified by their _desktop_file_id_.

The `[Desktop Entry]` section of this `level-zero.directory` file would so have only one of the following keys:

<table border="1">

<tbody>

<tr valign="top">

<td nowrap="nowrap">**Key**</td>

<td>**Description**</td>

<td nowrap="nowrap">**Value type**</td>

<td>**Req ?**</td>

</tr>

<tr valign="top">

<td>`ItemsList`</td>

<td>Same signification as</td>

<td>strings list</td>

<td>no</td>

</tr>

</tbody>

</table>

The `level-zero.directory` file may be searched for in `XDG_DATA_DIRS/file-manager/actions`. The first one found would be used.

Not finding a `level-zero.directory` file should not prevent actions or menus to be displayed. Instead, they just would be displayed in an unspecified, implementation-dependent, order.

The name `level-zero.directory` is chosen to not risk any collision with regular `.desktop` files.

## References

*   [Desktop Entry Specification](http://standards.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html)
*   [Desktop Menu Specification](http://standards.freedesktop.org/menu-spec/menu-spec-latest.html)
*   [XDG Base Directory Specification](http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html)
*   [Creating Konqueror Service Menus](http://developer.kde.org/documentation/tutorials/dot/servicemenus.html)
*   [Krusader UserActions](http://www.krusader.org/handbook/useractions.html)
*   [Thunar Custom Actions](http://thunar.xfce.org/pwiki/documentation/custom_actions)

## Contributors

*   Jonas Bähr
*   David Faure
*   Ted Gould
*   Hong Jen Yee "PCMan"
*   Michael Pyne
*   Liam R. E. Quin
*   Pierre Wieser
