# Building on Linux

helloSystem is designed for use with helloSystem, which is based on FreeBSD.

However, developers may want to verify that the code is reasonably platform independent by building on Linux from time to time.

``` .. note::
    That the code build does not necessarily mean that it works properly on Linux or that all features are implemented for Linux.
```

## Building in a chroot on a FreeBSD host

To verify that the code builds on Linux without needing a different development machine, one can use an [Alpine Linux](https://alpinelinux.org/) chroot in FreeBSD.

Beginning with build 0H165, helloSystem ships with an [alpine rc.d script](https://github.com/helloSystem/ISO/blob/experimental/overlays/uzip/hello/files/usr/local/etc/rc.d/alpine).
When started for the first time, this downloads a minimal root filesystem.

```
sudo service linux stop
sudo service debian stop
sudo service alpine onestart
sudo chroot /compat/alpine /bin/sh
```

In the chroot, build the essential helloSystem components

```
# launch, open, and other essential command line tools that are required
git clone https://github.com/helloSystem/launch
apk add qt5-qtbase-dev kwindowsystem-dev git cmake musl-dev alpine-sdk clang nano
mkdir -p launch/build
cd launch/build
cmake ..
sudo make -j $(nproc) install
cd ../../

# Menu
git clone https://github.com/helloSystem/Menu
sudo pkg install -y cmake pkgconf qt5-x11extras qt5-qmake qt5-widgets \
qt5-buildtools kf5-kdbusaddons kf5-kwindowsystem kf5-baloo libdbusmenu-qt5 \
qt5-concurrent qt5-qtmultimedia-dev libfm-extra-dev menu-cache-dev
mkdir -p Menu/build
cd Menu/build
cmake ..
sudo make -j $(nproc) install
cd ../../

# Filer
git clone https://github.com/helloSystem/Filer
apk add apk add qt5-qtbase-dev kwindowsystem-dev qt5-qttools-dev \
qt5-qtmultimedia-dev libfm-dev menu-cache-dev libfm-extra-dev \
kdbusaddons-dev baloo-dev xcb-util-wm-dev libdbusmenu-qt-dev git cmake musl-dev \

mkdir -p Filer/build
cd Filer/build
cmake ..
sudo make -j $(nproc) install
cd ../../
```

After you are done, 

```
sudo service alpine onestop
```

``` .. note::
    If the compiler crashes, make sure that /usr/bin/clang++ is being used rather than /usr/bin/c++. This can be edited in CMakeCache.txt.
```

## Running helloDesktop on Linux

Run Alpine Linux, e.g., in VirtualBox on helloSystem, or on real hardware.

* Download ISO from https://alpinelinux.org/downloads/, "Standard"
* User `root`, no password is the default
* Install to to a hard disk using the `setup-alpine` command, need to use a classic ("sys mode") installation
* Enable community repo by  `sed -i -e 's|^#||g' /etc/apk/repositories`
* Install KDE Plasma using `setup-desktop`; set up a user
* `rc-update add sddm` and `rc-service sddm start`
* Log into a KDE Plasma session on Alpine Linux. __Important:__ Select X11 session. Wayland doesn't work smoothly
* Optionally, install VirtualBox related guest packages using `apk search` and `apk add`
* `sudo su` to become root (there is no `sudo` configured on Alpine Linux by default)
* Build and `make install` the three core components of helloDesktop (launch, Menu, and Filer) as above
* From within the running KDE Plasma session, you can switch to the minimal helloDesktop with

```
#!/bin/sh

launch Menu &
sleep 1
launch Filer &
killall plasmashell
```

Menu shoud work including full text search in the filesystem.

The result will look somewhat like this:

![Screenshot](https://user-images.githubusercontent.com/2480569/200421869-96f81c37-0785-4416-ae43-bee920dd6a3e.png)

``` .. note::
    That the code runs does not necessarily mean that it works properly on Linux or that all features are implemented for Linux. Please keep in mind that for the best desktop experience, you should be using helloSystem which helloDesktop has been designed for.
```
