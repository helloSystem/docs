# Create Live Media

A __Live Medium__ is a storage device that can be used to start your computer with the helloSystem without having to install helloSystem to the internal storage of the computer. It allows you to try out helloSystem without making any changes to the software installed on your computer. Almost all functionality of helloSystem is available in Live mode, with very few exceptions. Changes being made, including files created, will be discarded when the system is shut down or retarted.

The __Create Live Media__ utility provides an easy and convenient way to create bootable Live Media on devices such as USB sticks. It downloads and writes Live ISOs to devices in one go.

![Create Live Media](https://user-images.githubusercontent.com/2480569/100794701-3bb03900-341e-11eb-8c18-e45fc68b7dbe.png)

This is useful if you are running helloSystem and would like to write a newer (or experimental) version of the system to a bootable storage device.

## Prerequisites

In order to create a Live medium, you need
* A computer running any version of helloSystem with the __Create Live Media__ utility
* A fast internet connection (a typical download is around 2 GiB)
* A suitable external storage device, e.g., a USB3 device. USB2 devices can be used but performance may be degraded. On some systems, other storage media such as SD cards or microSD cards can be used. Consult the documentation that came with your computer to determine which type of media can be used to start your computer.

``` .. note::
    The **Create Live Media** utility cannot be used on other operating systems such as Windows, Linux, or macOS.
    
    If you would like to create Live Media for helloSystem using one of those operating systems, you can use applications that can write images to USB storage devices, such as [balenaEtcher](https://www.balena.io/etcher/).
```

## Downloading and writing Live Media

The __Create Live Media__ utility downloads and writes a Live ISO image in one go to a storage medium. Open the __Create Live Media__ utility and follow the instructions on screen.

``` .. warning::
    The **Create Live Media** utility will overwrite the entire contents of the selected device, including all of its pre-existing partitions. Take extra caution when selecting the target device.
    
    This operation cannot be undone.
```

Once the image has been written to the device successfully, you can restart your computer to start from the Live Medium, or remove the device and insert it into another computer to start that computer from the Live Medium.
