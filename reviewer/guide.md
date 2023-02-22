# Reviewer's Guide

## Introduction
HelloSystem is an open-source operating system based on FreeBSD. Its goal is to provide a stable, user-friendly, and visually appealing system for desktop and laptop computers. The system is designed to be easy to use, highly customizable, and efficient, with an emphasis on minimalism and simplicity.

The purpose of this reviewer's guide is to provide an overview of helloSystem, as well as to offer guidance on how to use the system's features and capabilities. The guide includes information on system requirements, installation, user interface, features, performance, support options, and more.

Whether you are a new user looking to explore helloSystem for the first time, or an experienced user seeking to learn more about its features and capabilities, this guide should provide you with a comprehensive understanding of the system and its functionality.

## System Requirements
To run helloSystem, you will need a system that meets the following minimum requirements:

- 64-bit x86 processor
- 4 GB of RAM
- 30 GB of available hard disk space
- Graphics card capable of 1024x768 resolution

For optimal performance, we recommend the following:

- 8 GB of RAM or more
- Graphics card capable of 1920x1080 resolution or higher

Please note that helloSystem is not currently compatible with ARM-based processors.

When reviewing or benchmarking helloSystem, it is important to note that virtual machines may not provide an accurate representation of the system's stability, feature set, and performance. Therefore, we recommend that reviewers use real hardware for these purposes. Running helloSystem on actual hardware will provide a more authentic experience and allow reviewers to test the system's capabilities in a more realistic environment. Additionally, using real hardware will help to ensure that the system's hardware support is properly evaluated. For these reasons, we strongly advise against conducting tests and benchmarks in a virtual environment, even though VirtualBox guest drivers are preinstalled.

## Installation

Installing helloSystem is a relatively straightforward process. Follow these steps to install helloSystem on your system:

1. Download the helloSystem ISO file from the helloSystem website.
2. Burn the ISO file to a USB drive or DVD.
3. Insert the USB drive or DVD into your computer and boot from it.
4. Follow the on-screen instructions to install helloSystem.

helloSystem is designed to be installed on a dedicated SSD, and for the sake of simplicity currently cannot be installed alongside other operating systems on the same disk. Additionally, if you are running helloSystem on a device with a UEFI firmware, you may need to disable Secure Boot in order to boot into helloSystem.

If you encounter any issues during the installation process, please consult the helloSystem documentation or contact the [helloSystem discussion forum](https://github.com/helloSystem/hello/discussions/) for assistance.

## User Interface

The six-part series on [Linux desktop usability](https://medium.com/@probonopd/make-it-simple-linux-desktop-usability-part-1-5fa0fb369b42) by helloSystem's founder eventually lead to the design and development of helloSystem. The series explored aspects of  desktop usability, from user interface design to application packaging and distribution. The insights expressed in the series helped inform the design decisions behind helloSystem, with a focus on simplicity, ease of use, and discoverability. The indended result is a user-friendly and efficient operating system that is easy to use and customize, even for non-technical users.

The helloSystem user interface is designed to be intuitive, functional, and discoverable, with a range of features and tools to meet the needs of both new and experienced users. Here are some key concepts:

- **Command key** left to the spacebar: On systems with a Mac-style keyboard, the Command key is located to the left of the spacebar, which can be more comfortable for Mac users. When helloSystem is used with a PC keyboard, the Alt key functions as the Command key, being located in the same physical location on the keyboard.

- **Global menu bar**: helloSystem features a global menu bar, which is a menu bar that is located at the top of the screen, rather than within the application window. This provides for a consistent user experience across applications, even if those applications are written in non-native frameworks such as Gtk or Electron.

- **Keyboard layout and language autodetection**: When using a Mac or a [Raspberry Pi Keyboard and Hub](https://www.raspberrypi.com/products/raspberry-pi-keyboard-and-hub/), helloSystem will automatically detect the keyboard layout and language, removing the need to configure it manually.

- **Menu search and launcher**: helloSystem includes a powerful menu search and launcher, which can be used to quickly find and launch applications, files, and menu commands. It is located in the top right corner of the global menu bar and can be a true productivity booster, as it allows the system to be operated virtually only by using the keyboard.

- **Application bundles**: Applications on helloSystem are structured as self-contained bundles, which can be easily installed, removed, and updated.

- **`launch` command using a database**: helloSystem uses a database to manage launch commands, rather than relying on traditional XDG desktop files, which will provide better functionality, e.g., for applications that can be freely moved around in the fileystem without the need to update `.desktop` files.

- **Source code editability** for many Utilities: Many of the utilities included with helloSystem have their source code included and do not need to be compiled, making it easy for users to customize and contribute to the system. Right-click on an application icon and choose "Show Contents" to see and edit the source code.

- **Under Construction**: The "Under Construction" section of the menu provides access to various utilities and tools that are currently in development, and are looking for contributors to help bring them to completion.

- **Create Live Media** utility: helloSystem includes a tool for creating live media, which can be used to create a bootable USB or DVD to try helloSystem without installing it on your system. It can also burn the latest, frequently released, experimental ISO builds directly to USB sticks.

## Features
- Detailed list of features in helloSystem
- Purpose and functionality of each feature
- Examples of how to use each feature

## Performance
- Details of helloSystem's performance
- Benchmarks or tests conducted
- Comparisons to other similar operating systems

## Support
- Explanation of support options available for helloSystem
- Contact information for support (e.g., email or forums)

## Conclusion
- Summary of key points in the reviewer's guide
- Overall impression of helloSystem
