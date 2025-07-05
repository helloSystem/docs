# Writing man pages

Command line tools should be shipped with man pages.

:::{note}
To make fullest use of all features, man pages should be written in their native markup language, mdoc.

However, this has a quite steep learning curve, so the following can be used to get started quickly.
:::

One way to create man pages from Markdown is by using `pandoc`
and the template from https://github.com/pragmaticlinuxblog/pandocmanpage.

To convert Markdown to man:

```console
$ pandoc Desktop/launch.1.md -s -t man -o  Desktop/launch.1
$ /usr/bin/man ~/Desktop/launch.1
```

To convert man to txt:

```console
$ /usr/bin/man ~/Desktop/launch.1 | col -b > ~/Desktop/launch.txt
```

## Order of sections

For more information, see [`man mdoc`](https://www.freebsd.org/cgi/man.cgi?mdoc).

* `PROGNAME section`
* `NAME`
* `LIBRARY`
* `SYNOPSIS`
* `DESCRIPTION`
* `CONTEXT`
* `IMPLEMENTATION NOTES`
* `RETURN VALUES`
* `ENVIRONMENT`
* `FILES`
* `EXIT STATUS`
* `EXAMPLES`
* `DIAGNOSTICS`
* `ERRORS`
* `SEE ALSO`
* `STANDARDS`
* `HISTORY`
* `AUTHORS`
* `CAVEATS`
* `BUGS`
* `SECURITY CONSIDERATIONS`
