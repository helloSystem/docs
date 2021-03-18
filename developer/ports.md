# Working with FreeBSD Ports

In some situations it may be necessary to make changes to existing software that comes in FreeBSD packages.
This section describes how to make such changes using an example.

## Example

Suppose you would like to make a small change to the source code of software that comes as a FreeBSD package. Since packages are built from FreeBSD Ports, you need to modify the corresponding FreeBSD port.

Here is a real-life example on how to do that:

https://github.com/lxqt/qterminal/issues/474 can be fixed by changing a few lines in

https://github.com/lxqt/qtermwidget/blob/059d832086facb19035a07d975ea4fd05d36b1ec/lib/TerminalDisplay.cpp#L3206

Here is how to do it using FreeBSD Ports:

## Building the port without changes

Build the port without changes first to ensure it builds and works as expected.

```
# Build the library
# NOTE: Applications that have a library that is used by nothing but that application are just
# annoying because now you have to deal with two entities rather than one
cd /usr/ports/x11-toolkits/qtermwidget/
MAKE_JOBS_UNSAFE=yes ALLOW_UNSUPPORTED_SYSTEM=1 sudo -E make -j4

# Build the application
cd /usr/ports/x11/qterminal
QTermWidget5_DIR=/usr/ports/x11-toolkits/qtermwidget/work/stage/usr/local/lib/cmake/qtermwidget5/  MAKE_JOBS_UNSAFE=yes ALLOW_UNSUPPORTED_SYSTEM=1 sudo -E make -j4

# Run the application with the changed library
LD_LIBRARY_PATH=/usr/ports/x11-toolkits/qtermwidget/work/stage/usr/local/lib/ /usr/ports/x11/qterminal/work/stage/usr/local/bin/qterminal
```

## Making changes to the port

Now make changes to the port.

``` .. note::
    In the ports system you cannot just change the source code because it would be overwritten during the build process.
You first need to make a copy of the source code, then make the changes in the copy, then create a patch that will get applied automatically at build time.
```

```
# Copy the file to be changed
cd /usr/ports/x11-toolkits/qtermwidget
sudo cp work/qtermwidget-*/lib/TerminalDisplay.cpp work/qtermwidget-*/lib/TerminalDisplay.cpp.orig

# Make the change in the library
sudo nano work/qtermwidget-*/lib/TerminalDisplay.cpp
        dropText += QLatin1Char('\'');
        dropText += urlText;
        dropText += QLatin1Char('\'');
        dropText += QLatin1Char(' ');

# Make a patch
sudo make makepatch

# Build the library again
# sudo make clean # Run this only if the next line does nothing
MAKE_JOBS_UNSAFE=yes ALLOW_UNSUPPORTED_SYSTEM=1 sudo -E make -j4

# Run the application with the changed library
LD_LIBRARY_PATH=/usr/ports/x11-toolkits/qtermwidget/work/stage/usr/local/lib/ /usr/ports/x11/qterminal/work/stage/usr/local/bin/qterminal
```

As a result we have a patch:

```
% cat files/patch-lib_TerminalDisplay.cpp
--- lib/TerminalDisplay.cpp.orig        2020-11-03 08:19:26 UTC
+++ lib/TerminalDisplay.cpp
@@ -3099,10 +3099,10 @@ void TerminalDisplay::dropEvent(QDropEvent* event)
         // without quoting them (this only affects paths with spaces in)
         //urlText = KShell::quoteArg(urlText);
 
-        dropText += urlText;
-
-        if ( i != urls.count()-1 )
-            dropText += QLatin1Char(' ');
+        dropText += QLatin1Char('\'');
+        dropText += urlText; 
+        dropText += QLatin1Char('\'');
+        dropText += QLatin1Char(' ');
     }
   }
   else
```

## Making packages

Optionally, make packages for the ports. Note that `make build` needs to have run already before this step.

```
# Library
cd /usr/ports/x11-toolkits/qtermwidget/
sudo make package
ls work/pkg

# Application
cd /usr/ports/x11/qterminal
sudo make package
ls work/pkg
```
