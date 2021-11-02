# Update

Once you have installed the system to the hard disk in your computer, or an externally attached storage device, you may want to keep it recent by running the __Update__ utility from time to time.

``` .. note::
    This utility is currently in  **Developer Preview** status and is intended for developers and testers. Only use it if you have a backup of your system or if you are running on a test system that you can set up from scratch if needed.
```

This utility
* Creates a new Boot Environment (bootable partial snapshot). __This is not a full replacement for a backup__ but should allow you to roll back to the state before the update, should something go wrong
* Updates the FreeBSD operating system components (kernel and userland)
* Updates all FreeBSD Packages
* Currently does _not_ update any applications that came with helloSystem as native application bundles

![](https://user-images.githubusercontent.com/2480569/137626617-ffa339e5-5633-4fa4-84a5-9dd9c7f4b966.png)

## Testing 

Please follow this exact procedure when testing the Update utility:

* Install a helloSystem 0.7.0 pre-release build to hard disk.
* Open QTerminal and run `sudo pkg lock --yes automount slim gvfs dejavu liberation-fonts-ttf`. This step is __important__ because otherwise the update will overwrite carefully crafted helloSystem customizations. (There may be more packages that need to be locked as well.)
* Run the __Update__ utility and follow the on-screen instructions.
* Once the update has completed, restart your computer to make full use of the updated software.
* Run the __Boot Environments__ preferences application and check that there is a boot environment that you can switch back to in the case you are not satisfied with the updated system. 

Please submit any problems you might be running into to [this issue](https://github.com/helloSystem/Utilities/issues/33).

Thanks for testing the Update utility.
