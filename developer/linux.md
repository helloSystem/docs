# Building on Linux

helloSystem is designed for use with helloSystem, which is based on FreeBSD.

However, developers may want to verify that the code is reasonably platform independent by building on Linux from time to time.

``` .. note::
    That the code build does not necessarily mean that it works properly on Linux or that all features are implemented for Linux.
```

To verify that the code builds on Linux without needing a different development machine, one can use an Alpine Linux chroot in FreeBSD.

```
sudo service linux stop
sudo service debian stop
sudo service alpine onestart
sudo chroot /compat/alpine
```

In the chroot, execute

```
apk add --no-cache qt5-qtbase-dev kwindowsystem-dev git cmake alpine-sdk nano
git clone https://github.com/helloSystem/launch
cd launch/
mkdir build
cd build
cmake ..
make -j $(nproc)
```

After you are done, 

```
sudo service alpine onestop
```
