# Hardware Probe

The __Hardware Probe__ utility collects hardware details of your computer and can anonymously upload them to the public database at [bsd-hardware.info](https://bsd-hardware.info/?d=helloSystem).

This can help users and operating system developers to collaboratively debug hardware related issues, check for operating system compatibility and find drivers.

You will get a permanent probe URL to view and share collected information.

## Data Privacy

The Hardware Probe utility can upload the hardware probe to the hardware database. The probe will be published publicly under a permanent URL to view the probe.
           
Private information (including the username, machine's hostname, IP addresses, MAC addresses, UUIDs and serial numbers) is NOT uploaded to the database.

The tool uploads 32-byte prefix of salted SHA512 hash of MAC addresses/UUIDs and serial numbers to properly identify unique computers and hard drives. All the data is uploaded securely via HTTPS.

``` .. note::
    By using this utility to upload your hardware probe, you agree that
information about your hardware will be uploaded
to a publicly visible database.

    Do not use this utility if you do not agree with this.
```

By uploading your hardware probe you confirm uploading of 32-byte prefix of salted SHA512 hash of MAC addresses and serial numbers to prevent duplication of computers in the database.

The web service and the database are operated by linux-hardware.org. The authors of the graphical Hardware Probe utility are not associated with the operator of the web service. Please contact https://linux-hardware.org/index.php?view=contacts in case of questions and in case you wish accidentally submitted probes to be removed from the database.
