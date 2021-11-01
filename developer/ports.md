# Working with FreeBSD Ports

In some situations it may be necessary to make changes to existing software that comes in FreeBSD packages.
This section describes how to make such changes using an example.

## Example

Suppose you would like to make a small change to the source code of software that comes as a FreeBSD package. Since packages are built from FreeBSD Ports, you need to modify the corresponding FreeBSD port.

Here is a real-life example on how to do that:

https://github.com/lxqt/qterminal/issues/474 can be fixed by changing a few lines in

https://github.com/lxqt/qtermwidget/blob/059d832086facb19035a07d975ea4fd05d36b1ec/lib/TerminalDisplay.cpp#L3206

Here is how to do it using FreeBSD Ports:

## Installing the ports tree

Unfortunately one has to download/update the whole ports tree, containing all available ports, even if one just wants to make a change to one or a few of the ports.

```
sudo portsnap fetch
sudo portsnap fetch update
sudo portsnap extract
```

If you are running an end-of-life FreeBSD version such as 12.1, you also need to

```
export ALLOW_UNSUPPORTED_SYSTEM=1
# Or in csh
setenv ALLOW_UNSUPPORTED_SYSTEM YES
```

## Building the port without changes

Build the port without changes first to ensure it builds and works as expected.

```
cd /usr/ports/x11-toolkits/qtermwidget/

# Install all build-time dependencies from packages
make build-depends-list | cut -c 12- | xargs pkg install -y

# Build the library
# NOTE: Applications that have a library that is used by nothing but that application are just
# annoying because now you have to deal with two entities rather than one
MAKE_JOBS_UNSAFE=yes sudo -E make -j4

# Now, the application itself
cd /usr/ports/x11/qterminal

# Install all build-time dependencies from packages
make build-depends-list | cut -c 12- | xargs pkg install -y

# Build the application
QTermWidget5_DIR=/usr/ports/x11-toolkits/qtermwidget/work/stage/usr/local/lib/cmake/qtermwidget5/  MAKE_JOBS_UNSAFE=yes sudo -E make -j4

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
        QChar q(QLatin1Char('\''));
        dropText += q + QString(urlText).replace(q, QLatin1String("'\\''")) + q;
        dropText += QLatin1Char(' ');

# Make a patch
sudo make makepatch

# Build the library again
# sudo make clean # Run this only if the next line does nothing
MAKE_JOBS_UNSAFE=yes sudo -E make -j4

# Run the application with the changed library
LD_LIBRARY_PATH=/usr/ports/x11-toolkits/qtermwidget/work/stage/usr/local/lib/ /usr/ports/x11/qterminal/work/stage/usr/local/bin/qterminal
```

As a result we have a patch:

```
% cat files/patch-lib_TerminalDisplay.cpp
--- lib/TerminalDisplay.cpp.orig        2020-11-03 08:19:26 UTC
+++ lib/TerminalDisplay.cpp
@@ -3099,7 +3099,9 @@ void TerminalDisplay::dropEvent(QDropEvent* event)
         // without quoting them (this only affects paths with spaces in)
         //urlText = KShell::quoteArg(urlText);
 
-        dropText += urlText;
+        QChar q(QLatin1Char('\''));
+        dropText += q + QString(urlText).replace(q, QLatin1String("'\\''")) + q;
+        dropText += QLatin1Char(' ');
 
         if ( i != urls.count()-1 )
             dropText += QLatin1Char(' ');
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

## Creating a port from scratch

The [FreeBSD Porter's Handbook](https://docs.freebsd.org/en/books/porters-handbook/) is the authoritative source on how to write new ports from scratch. This section shows a hands-on example on how to package a set of tools from a GitHub repository.


``` .. note::
    This section is a work in progress. Corrections are welcome.
```

First, prepare the Ports environment:

```
sudo su
export ALLOW_UNSUPPORTED_SYSTEM=YES
# or on csh
setenv ALLOW_UNSUPPORTED_SYSTEM YES
pkg install portlint subversion
echo DEVELOPER=yes >> /etc/make.conf
portsnap fetch extract update # Run this from time to time
```

Next, create a directory for the new port:

```
mkdir /usr/ports/sysutils/fluxengine
cd /usr/ports/sysutils/fluxengine
```

Create `Makefile` with the following content:

```
# $FreeBSD$

PORTNAME=       fluxengine
DISTVERSION=    572
CATEGORIES=     sysutils

MAINTAINER=     probono@puredarwin.org
COMMENT=        USB floppy disk interface for reading and writing non-PC disk formats

LICENSE=        MIT

LIB_DEPENDS=    libsqlite3.so:databases/sqlite3 \
                libstdc++.so:lang/gcc9

BUILD_DEPENDS=  ninja:devel/ninja

USES=           gmake

USE_GITHUB=     yes
GH_ACCOUNT=     davidgiven
GH_TAGNAME=     61ff48c

PLIST_FILES=    bin/brother120tool \
                bin/brother240tool \
                bin/fluxengine

do-install:
        ${INSTALL_PROGRAM} ${WRKSRC}/brother120tool ${STAGEDIR}${PREFIX}/bin/
        ${INSTALL_PROGRAM} ${WRKSRC}/brother240tool ${STAGEDIR}${PREFIX}/bin/
        ${INSTALL_PROGRAM} ${WRKSRC}/fluxengine ${STAGEDIR}${PREFIX}/bin/

.include <bsd.port.mk>
```

Notes
* See `ls /usr/ports/` for possible categories, such as `sysutils`
* See [5.2. Naming](https://docs.freebsd.org/en/books/porters-handbook/makefile-naming.html) for naming and versioning conventions
* The lines must be in a defined order. Run `portlint` to get information on this and re-order until it no longer complains
* Run `make stage-qa` to find out dependencies. Using something like `make stage-qa 2>&1 | grep "you need" | sort | uniq | cut -d " " -f 4` can speed this up
* The `do-install` section is needed in this example because there is no `make install` in the original software's Makefile

Create `pkg-descr` based on the description on the GitHub [README.md](https://github.com/davidgiven/fluxengine):

```
The FluxEngine is a very cheap USB floppy disk interface capable of
reading and writing exotic non-PC floppy disk formats.
It allows you to use a conventional PC drive to accept Amiga disks,
CLV Macintosh disks, bizarre 128-sector CP/M disks,
and other weird and bizarre formats.
 :
The hardware consists of a single, commodity part with a floppy drive
connector soldered onto it. No ordering custom boards,
no fiddly surface mount assembly, and no fuss:
nineteen simpler solder joints and you're done.

WWW: http://cowlark.com/fluxengine/
```

Notes
* For details please refer to [3.2. Writing the Description Files](https://docs.freebsd.org/en/books/porters-handbook/porting-desc.html).

Create the checksum file by running

```
make makesum
```

Check the Makefile with

```
portlint
```

and correct any mistakes it reports, then repeat.

Once `portlint` says `looks fine`, try to build by running

```
make
```

Note that the compilation will fail. This is because in this case the application needs to be built with `gmake` rather than `make`.

Run tests

```
make stage
make stage-qa
make package
make install
make deinstall
```

None of these must produce errors. See [3.4. Testing the Port](https://docs.freebsd.org/en/books/porters-handbook/porting-testing.html) for details.

At this point it may be a good idea to have an experienced FreeBSD Ports developer have a look at your new port.

Once everything looks good, prepare a `.shar` file for submitting it to https://bugs.freebsd.org/submit/:

```
rm -rf work/
cd ..
tar cf  fluxengine.shar --format shar fluxengine
```
