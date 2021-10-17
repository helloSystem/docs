 # Binary Compatibility
 
Binary compatibility is an important concept in software engineering. It allows applications compiled on a build system to run on user's target systems without forcing them to upgrade their entire system all the time. As the FreeBSD wiki page on binary compatibility points out, "a lot of downstream users keep systems for about 10 years and want to be able to keep running their stack on top of FreeBSD without worrying that an upgrade will break things."

``` .. note::
    This page is in draft status and needs to be reviewed by experienced FreeBSD developers. Pull requests welcome.
```

 ## Application compatibility
 
 The Application Binary Interface (ABI) defines which applications can run on which systems. The two main factors in determining application compatibility are the FreeBSD version (e.g., `12.x`) and the version of packages (e.g., `quarterly`).
 
 * Applications compiled on one major version of FreeBSD are expected to run on subsequent minor versions of the same major version of FreeBSD if the packages of the dependencies on the target system are no older than on the build system. __Example:__ An application compiled on FreeBSD 12.0 is expected to run on FreeBSD 12.1 and 12.2 if the packages of the dependencies on the target system are no older than on the build system 
 * Applications compiled on one major version of FreeBSD are expected to run on subsequent major versions of FreeBSD if compatibility libraries are installed. __Example:__ An application compiled on FreeBSD 3.2 is expected to run on FreeBSD 14 if compatibility libraries are installed. __But__ this is what happens when you try to `pkg-static add` a package built on FreeBSD 12 on a FreeBSD 13 machine: `pkg-static: wrong architecture: FreeBSD:12:amd64 instead of FreeBSD:13:amd64` - apparently `pkg-static add` does not make use of the compatibility assumption but this can be worked around by exporting, e.g., `ABI=freebsd:12:amd64`; `pkg install` does not seem to have this issue.
 
 
### Recommendation for building binary compatible applications

Build on the `.0` minor version for each still-supported major version of FreeBSD, using `release_0`, `release_1`, `release_2`,... but __NOT__ `quarterly`, `latest` packages as those are moving targets which will vanish over time.

This should allow the application to run on all still-supported FreeBSD releases.
 
 ## Kernel module compatibility
 
 The Kernel Binary Interface (KBI) defines which kernel extensions can run on which systems.
 
``` .. note::
    Section to be written. Pull requests welcome.
```
  
  * Normally, kernel extensions compiled on one major version of FreeBSD are expected to run on subsequent minor versions of the same major version of FreeBSD. However, there are notable exceptions such as the `i915kms` package that contains the Intel GPU driver.
 
 __Note:__ The `i915kms` package that contains the Intel GPU driver breaks on 12.2-RELEASE.
 
``` .. note::
    Explanation to be written. Pull requests welcome.
```
 
 
### Recommendation for building binary compatible kernel modules

Build on the `.0` minor version for each still-supported major version of FreeBSD. Test whether the kernel module runs on all subsequent minr versions and build for those minor versions separately in case it does not. This should allow the kernel module to run on all still-supported FreeBSD releases.

 
 ## References
 
 * https://wiki.freebsd.org/BinaryCompatibility describes best practices for maintaining binary compatibility in FreeBSD
 * [i915kms package breaks on 12.2-RELEASE](https://forums.freebsd.org/threads/i915kms-package-breaks-on-12-2-release-workaround-build-from-ports.77501/)
