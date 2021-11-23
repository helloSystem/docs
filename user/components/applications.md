# Applications

Most applications in helloSystem come in the form of __application bundles__. An application bundle is an application that looks and behaves like a file but is actually a directory, containing not only the application but also auxiliary files such as icons and other resources. To view the contents of an application bundle, right-click on it and select "Show Contents". This is useful especially for open source applications written in languages such as PyQt5, because you can interactively edit the source code and test your changes.

![Viewing the contents of an application bundle](https://pbs.twimg.com/media/EoK9u7vXUAAJFPn?format=png)

helloSystem comes with some applications out of the box, and some applications need to be downloaded before they can be used.

You find the applications in the menu under "System -> Applications", and in the `/Applications` folder on your hard disk, although they can also be placed in other locations if you so desire.

```eval_rst
.. toctree::
   :maxdepth: 2
   :glob:

   applications/*
``` 
