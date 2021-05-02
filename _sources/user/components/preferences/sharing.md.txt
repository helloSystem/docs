# Sharing

The __Sharing__ preferences application lets you make your computer accessible from the network.

![Sharing.app](https://pbs.twimg.com/media/EoK8buxXYAIdtvJ?format=png)

## Computer Name

The __Computer Name__ (hostname) is displayed. You can change it. Changes in the Computer Name will take effect upon restarting the computer.

## Remote Login

Check the __Remote Login__ checkbox to make your computer accessible over ssh.

## Screen Sharing

Check the __Screen Sharing__ checkbox to make the screen of your computer accessible through VNC over ssh and advertise it on the network. This allows another user who has an account on your computer to view the screen, and to control the computer as if they were sitting in front of it. This can be helpful, e.g., for getting help from colleagues. The __Screen Sharing__ checkbox will automatically be unchecked when the computer is restarted or after a connection has been made and has ended.

## Accessing the screen of remote computers

## Accessing the screen of a remote computer that has Screen Sharing enabled

If Screen Sharing is active on the remote computer, then you can use [SSVNC](http://www.karlrunge.com/x11vnc/ssvnc.html) (available for Windows, Mac OS X, and various Unix-like systems) to access the machine over the local area network.

In SSVNC please do: 
* Under "VNC Host_Display" please enter: <IP Address>:0
* Options... -> Check the "Use SSH" box and the "Unix Username & Password" box
* Under "Unix Username" enter the username you have set when you installed helloSystem
* Under "Unix Password" enter the password you have set when you installed helloSystem

## Accessing the screen of a remote computer that has Remote Login enabled

If Screen Sharing is not active but Remote Login is active on the remote computer, then you can connect over the local area network and enable Screen Sharing as follows. Replace `user` with your username on the remote computer, and `FreeBSD.local.` with the hostname of the remote computer:

```
ssh -t -L 5900:localhost:5900 user@FreeBSD.local. 'x11vnc -display :0 -auth /home/user/.Xauthority -once -localhost'
```

Log into the remote computer. Then start the Remote Desktop client as follows:

```
ssvncviewer localhost
```

You should now be able to see and operate the screen.
