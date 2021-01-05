# Specifications

helloSystem is designed to be friendly and welcoming. The desired user experience informs the specifications embraced for use in helloSystem and applications running on it.

## Specifications embraced for use in helloSystem

These specifications cover technologies that are enthusiastically embraced in helloSystem and/or are recommended to be used in applications running on it.

* __mDNS__: Allows hostnames of devices to be published to the network, so that devices can be accessed using their names rather than using IP numbers.
* __DNS-SD/Zeroconf__: Allows for the discovery of services on the network, such as websites, SSH servers, SFTP shares, etc. If an application can handle certain types of network services, it should discover such services using DNS-SD/Zeroconf. For example, a Terminal application might offer to connect to SSH servers on the network discovered with DNS-SD/Zeroconf.
* __IPP Everywhere__: Allows printers to "just work" without configuring printer drivers.
* __AppImage__: Allows applications to be shipped and used as single files. helloSystem may predominantly use this format for Linux applications in the future.
* __Markdown__: The standard format for all documentation and other written text.
* __UTF-8__: The default encoding for text.

This list is not exhaustive.

## Conventions devloped for use in helloSystem

These conventions cover technologies that are embraced for being used in helloSystem and applications running on it.

* __Simplified application bundles:__ The format helloSystem predominantly uses for native applications. Derived from the GNUstep `.app` bundle format, but further simplified. Not formally specified yet. 

This list is not exhaustive.

## Specifications with relevance for helloSystem

These specifications cover technologies that may have relevance for helloSystem and are mostly considered for compatibility reasons. Their use within helloSystem may decline over time as more native replacements become available.

* __ICCCM/EWMH__: Allows windows to be managed on Xorg. [This page in the picom wiki](https://github.com/yshui/picom/wiki/Window-states-management) gives an overview
* __D-Bus__: Allows processes on the system to interact with each other (inter-process communication, IPC)
* __XDG Desktop specification__: Although helloSystem uses simplified application bundles to provide the desired user experience, some existing applications in FreeBSD ports and packages may come with `.desktop` files. To maintain compatibility with the vast body of existing applications, helloSystem  needs to provide a basic implementation of this specification, although its use should be minimized in helloSystem to allow for the desired user experience. For example, all handling of `.desktop` files could be left to one command line tool such as `desktop2app` that would convert `.desktop` files into the format used natively in helloSystem. Other uses of the XDG Desktop specification may be phased out in the future

This list is not exhaustive.
