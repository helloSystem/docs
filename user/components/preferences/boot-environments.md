# Boot Environments 

_Boot Environments_ are bootable clones of snapshots of the working system. Boot Environments allow you to create a safe failback Boot Environmnent before upgrading or making major changes to the system.

Other applications may create Boot Environmnents automatically before performing critical operations such as major operating system upgrades.

``` .. warning::
    Boot Environments by default do not cover all locations, such as `/home` where your personal data is usually stored.
```

The __Boot Environments__ preferences application lets you view, create, remove, mount, and boot into Boot Environments.

``` .. note::
    Boot Environments functionality cannot be used when the system is running from Live media. It can only be used when the system has been installed to a disk.
```

## Viewing Boot Environments

Open the __Boot Environments__ preferences application. If you have a user password set, you will be asked to enter your credentials. Only users in whe administrative group (`wheel`) can use the Boot Environments application by default.

You will see the available Boot Environments.

## Creating Boot Environments

To create a new Boot Environment, click "New..." and enter a name for the new Boot Environment.

## Removing Boot Environments

Select a Boot Environment by clicking on it, and then press "Remove". Note that you cannot remove the currently active Boot Environment.

## Mounting Boot Environments

You can make available, or "mount", existing Boot Environments, e.g., in order to inspect them or to copy files from there.

To do this, select a Boot Environment by clicking on it, and then press "Mount". Note that you cannot mout the currently active Boot Environment since it is already mounted at `/`.

The selected Boot Environment will be mounted, and a Filer window will be opened at the mountpoint of the Boot Environment.

## Booting into a Boot Environment

Activate a Boot Environment by checking its checkbox, and then press "Restart...". The computer will restart into the selected Boot Environment.

## More Information

Advanced users can use the `bectl` command on the command line, which the __Boot Environments__ preferences application is using under the hood.

For more information regarding Boot Environments, please refer to the [ZFS Boot Environments](https://bsd-pl.org/assets/talks/2018-07-30_1_S%C5%82awomir-Wojciech-Wojtczak_ZFS-Boot-Environments.pdf) presentation by Sławomir Wojciech Wojtczak.
