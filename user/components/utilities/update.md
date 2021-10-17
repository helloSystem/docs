# Update

Once you have installed the system to the hard disk in your computer, or an externally attached storage device, you may want to keep it recent by running the __Update__ utility from time to time.

``` .. note::
    This utility is currently in  **Developer Preview** status and is intended for developers and testers. Only use it if you have a backup of your system or if you are running on a test system that you can set up from scratch if needed.
```

## Testing 

Please follow this exact procedure when testing the Update utility:

* Install a helloSystem 0.7.0 pre-release build to hard disk.
* Open QTerminal and run `sudo pkg lock --yes automount slim gvfs dejavu liberation-fonts-ttf`. This step is __important__ because otherwise the update will overwrite carefully crafted helloSystem customizations. (There may be more packages that need to be locked as well.)
* Run the __Boot Environments__ preferences application and create a new boot environment that you can switch back to in the case you are not satisfied with the updated system. __This is not a replacement for a backup.__
* Run the __Update__ utility and follow the on-screen instructions.
* Once the update has completed, restart your computer to make full use of the updated software.

Please submit any problems you might be running into to [this issue](https://github.com/helloSystem/Utilities/issues/33).

Thanks for testing the Update utility.
