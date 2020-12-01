# Install FreeBSD

Once you have tried out helloSystem from the live medium, you may want to install the system to the hard disk in your computer, or an externally attached storage device.

The __Install FreeBSD__ utility lets you install helloSystem on your computer from a running Live system.

``` .. note::
    The utility is called  **Install FreeBSD** to signify that helloSystem contains a largely unmodified FreeBSD core operating system. It might be renamed "Install helloSystem" in the future.
```

![Install FreeBSD](https://user-images.githubusercontent.com/2480569/93003377-7d77c480-f53e-11ea-9e2d-aed1b41a17df.png)

When you install helloSystem using the __Install FreeBSD__ utility, the installed system will behave like the Live system in most aspects.

## Prerequisites

* A bootable helloSystem Live Medium
* A computer capable of starting from the Live Medium
* An internal or external storage device with 8 GB of storage space. More space is highly recommended to allow for adding applications and documents

## Installing helloSystem

Start your computer from a helloSystem Live Medium. Open the __Install FreeBSD__ utility and follow the instructions on screen.

The installer starts by presenting a summary of FreeBSD. Click on "Continue". To install the software, you must agree to the terms of the software license agreemement. Click on "Continue" to proceed. Click on a destination disk on which the operating system should be installed. A warning will inform you that the entire disk will be erased. Confirm whether you want to do this by clicking on the appropriate button.

``` .. warning::
    The **Install FreeBSD** utility will overwrite the entire contents of the selected device, including all of its pre-existing partitions. Take extra caution when selecting the target device.
    
    This operation cannot be undone.
```

If you are really sure that you have selected the correct device, click "Continue". 

In the next step, you will create an account for the main user of the computer. The information entered here is used to identify the main user of the computer. This user will have administrative permissions (will be member of the `wheel` group).

* In the field __Full Name__, enter your first name(s), followed by a blank, followed by your last name. Example: `John Doe`. This field can be left blank if you prefer not to provide your full name
* The field __Username__ will be automatically populated with a suggested username. It must not contain any special characters such as blanks. You can override the suggested default if you like. Example: `jdoe`
* Enter a password into the __Password__ field. Repeat the same password in the __Retype Password__ field. These fields can be left blank if you prefer not to use a password, but this will mean that anyone with access to your computer will be able to log in, and you will not be able to log in over the network
* The field __Computer Name__ will be automatically populated with a suggested computer name (hostname). This name will be used to identify your computer on the local area network. It must not contain any special characters such as blanks. You can override the suggested default if you like. Example: `Johns-TravelMate-B117-M`
* Check the checkbox __Enable users to log in over the network (ssh)__ if you would like to allow accessing the computer remotely. By default, this requires a passwort to be set for the computer account
* Check the checkbox __Set time zone based on current location__ if you would like timezone on the installed system to be set automatically. This feature requires an active internet connection

Click "Continue" to proceed. The system will be installed to the selected disk. This process typically takes a couple of minutes depending on your system configuration, during which a progress bar will be shown.

You can click on "Installer Log" at any time to see a detailed log of the actions performed by the installer and details on any possible errors.

Once the installation has completed, remove the Live medium from your computer and click the "Restart" button to start the newly installed system.
