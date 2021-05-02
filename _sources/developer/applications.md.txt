# Applications

Applications specifically written for helloSystem, especially Preferences and Utilities applications, should be
* Simple to use
* Easy to hack on
* Open Source (2-clause BSD licensed by default, but similar permissive licenses may also be acceptable)
* Ideally written in PyQt
* Come as simplified `.app` bundles with no external dependencies apart from what comes with helloSystem by default on the Live ISO

Some of the example applications and utilities are written in Python with PyQt. This is designed to invite (power) users to have a look at the code, start to experiment, and possibly eventually contribute. Especially when used in conjunction with the simplified `.app` bundle format and with an IDE with autocompletion, this makes for a _very_ accessible development environment with _very_ low barriers to entry. No source code to search and download, no compilers, just open the `.app` bundle and start hacking away. Tiny example applications like `Log.app` and `Calendar.app` are included that anyone should be able to understand in no time.

Please see [https://github.com/learnpyqt/15-minute-apps](https://github.com/learnpyqt/15-minute-apps) for what we mean by "Simple to use" and "Easy to hack on".

For an introduction to [Creating GUI applications with Python & Qt5](https://www.learnpyqt.com/pyqt5-book/) you may be interested in the book with the same name by Martin Fitzpatrick. There is also a forum at [forum.learnpyqt.com](https://forum.learnpyqt.com/).

[![](https://hellosystem.github.io/docs/_static/book-pyqt5.png)](https://www.learnpyqt.com/pyqt5-book/)

## Using .ui files in PyQt

Using Qt Creator, you can also create and edit graphical user inferfaces for __Python__ based applications using `.ui` files. These can be used in PyQt like this:

```
#!/usr/bin/env python3
# This Python file uses the following encoding: utf-8


import sys
import os


from PyQt5.QtWidgets import QApplication, QWidget
from PyQt5.QtCore import QFile
from PyQt5.uic import loadUi


class Widget(QWidget):
    def __init__(self):
        super(Disks, self).__init__()
        self.load_ui()

    def load_ui(self):
        path = os.path.join(os.path.dirname(__file__), "form.ui")
        ui_file = QFile(path)
        ui_file.open(QFile.ReadOnly)
        loadUi(ui_file, self)
        ui_file.close()


if __name__ == "__main__":
    app = QApplication([])
    widget = Widget()
    widget.show()
    sys.exit(app.exec_())
```
