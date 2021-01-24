 # launch
 
 ```eval_rst
 .. epigraph::

    "It’s not just what it looks like and feels like. Design is how it works."

    -- Steve Jobs
```
 
 The `launch` command is used to launch graphical applications on helloSystem. When you select an application from the [Menu](menu.md) or the [Dock](dock.md), then the `launch` command is invoked to actually launch the application.
 
 ```eval_rst
 .. hint::

     As an end user who is using the graphical user interface exclusively, you will not need to interact with the `launch` command directly and can skip this section.
 ```
 
 ## Background
 
 On UNIX systems, applications are typically launched by entering the name of the executable file, which is searched in a fixed list of directories determined by the `$PATH` environment variable. 
 
 Many graphical desktop environments use `.desktop` files to integrate applications with the system. While this has traditionally worked well for installed applications, it does not work well for dynamically changing applications that are moved in the filesystem, such as `.app` bundles or `.AppDir` directories. Also, it does not handle mutliple versions of the same application gracefully. Hence, helloSystem uses the `launch` command to launch graphical applications. This has the following advantages:
 
 * You do not need to know the path to the application to be launched, even if the applciation is not on the `$PATH`
  * If multiple versions of an application are available on the system, the most recent one will be launched automatically (unless specified otherwise by the user) __(to be implemented)__
 * If something goes wrong and the application cannot be launched, then a graphical error message will be shown on the screen
 
 ![Graphical error message if something goes wrong](https://pbs.twimg.com/media/EoLKXl7WEAAWCtQ?format=png)
 
 ## Using the `launch` command
 
  Whenever possible, graphical applications should be launched through the `launch` command on helloSystem.

  There are several ways in which the `launch` command can be invoked:
 
 * `launch /Applications/Filer.app`
 * `launch Filer.app`
 * `launch Filer`
 
Note that capitalization can have subtle effects:
 
* `launch audacity` launches `audacity` from the `$PATH` if it exists anywhere on the `$PATH`
* `launch Audacity` launches e.g., `/Applications/Audio/Audacity.app/Audacity` if it exists there or in other well-known application locations (because no `Audacity` exists anywhere on the `$PATH`)
