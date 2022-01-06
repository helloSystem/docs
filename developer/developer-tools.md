# Developer Tools

Starting with helloSystem 0.7.0, compilers, headers, `.o` files and other files for developers are not shipped on the helloSystem Live ISO by default in order to reduce the ISO size. You need to install the Developer Tools from `developer.img` which is a separate download from the same location you obtained the Live ISO (e.g., for 0.7.0, this is https://github.com/helloSystem/ISO/releases/tag/r0.7.0).

The __Developer__ folder in the __Applications__ folder contains useful development tools for use with helloSystem.

* __PyCharm CE__: A powerful integrated development environment (IDE) for the Python language which is used for
many of the utilities and preferences applications in helloSystem
* __Qt Creator__: The integrated development environment (IDE) for Qt-based applications, such as Menu, Dock, and Filer.
Includes graphical user interface editors for QtWidgets-based user interfaces (such as Menu and Filer) using `.ui` files 
and for Qml-based user interfaces (such as Dock) using `.qml` files.
The user interfaces generated in Qt Creator can be used in Qt application written in C++ or Python
* __LiteIDE__: An integrated development environment (IDE) for the Go language. Go is recommended
for long-running processes such as servers and for processes with parallelism
* __Zeal__: A browser for documentation sets, also known as "docsets". Docsets can be downloaded from within the application
and are available for many languages and environments, including Python, Qt, and Go.

To minimize the initial download size of the helloSystem image, the applications in the Developer folder
need to be downloaded prior to first use. You will be guided through this automatic process when you launch these
applications for the first time. After the applications have been downloaded, you can use them without an active
network connection.
