# Filer

__Filer__ is the application that you can use to manage objects like files, folders, and applications on your computer.

Filer can perform typical tasks of a file manager:
* Open files and folders
* Create, move, and delete files and folders

In helloSystem, many tasks are done in the Filer that would require extra tools in other operating systems. For example, you can use the Filer to 
* Launch applications (instead of using a dedicated launcher)
* Make applications available to the system (instead of using a package manager or compiling from source)
* Remove applications (instead of using a package manager)
* Accessing files on remote computers (instead of using a dedicated application that can access files over ssh/sftp)

## Launching applications

To launch an application, double-click it in Filer. In case you double-click on a binary that is lacking the execute permission, a dialog will ask you whether you would like to make the binary executable.

## Making applications available to the system

Applications for helloSystem typically come as application bundles. An application bundle looks like a file but is actually stored as a directory on disk. To make an application available to the system, simply move or copy it to one of the well-known locations for applications, such as `/Applications` for system-wide applications, or `~/Applications` (in your home directory) for per-user applications.

In addition to applications specifically offered for helloSystem, advanced users can use the tools provided by FreeBSD to compile applications from the ports tree, and/or to install FreeBSD packages.

## Removing applications

To remove an application from the system, move it to the Trash.

## Accessing files on remote computers

Computers on the local area network that are offering access via  SFTP are automatically discovered and are shown in the "Network" area of Filer. Double-click on a network directory to access it. You will be asked to provide valid credentials (username, password) of an account on the remote computer. For this to work, computers need to provide SFTP services and announce them over dns-sd (Zeroconf, Bonjour).

It is also possible to access files on computers that are not on the local area network. To do so, enter `sftp://hostname.tld` in the address bar of Filer and press the Enter key.
