# Working with the FreeBSD base system

In some situations it may be necessary to make changes to existing software that comes in the FreeBSD base system.
This section describes how to make such changes using an example.

## Example

Suppose you would like to make a small change to the source code of software that comes in the FreeBSD base system.

Here is a real-life example on how to do that:

https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=251025 can be fixed by changing a few lines in

https://github.com/freebsd/freebsd-src/blob/main/usr.sbin/efivar/efivar.c

## Installing the FreeBSD source code

Unfortunately one has to download/update the whole FreeBSD source code, even if one just wants to make a change to one command line tool.

From http://ftp.freebsd.org/pub/FreeBSD/releases/amd64/12.2-RELEASE/ (or from whatever FreeBSD version you are using) download `src.txz`. Then:

```
cd /
sudo tar xf ~/Downloads/src.txz
rm ~/Downloads/src.txz
```

## Building a command line tool without changes

Build the command line tool without changes first to ensure it builds and works as expected.

```
cd /usr/src/usr.sbin/efivar/
make
/usr/obj/usr/src/amd64.amd64/usr.sbin/efivar/efivar
```

## Making changes 

Now make changes to the command line tool.

```
cd /usr/src/usr.sbin/efivar/
rm efivar.c
# From https://reviews.freebsd.org/D29620
wget "https://reviews.freebsd.org/file/data/qquakxqeqeeepcbml5cy/PHID-FILE-ryp4c3imjqswnsjqiip3/usr.sbin_efivar_efivar.c" -O efivar.c
make
/usr/obj/usr/src/amd64.amd64/usr.sbin/efivar/efivar
```
