# Writing man pages

Command line tools should be shipped with man pages.

One way to create man pages from Markdown is by using `pandoc`
and the template from https://github.com/pragmaticlinuxblog/pandocmanpage.

To convert Markdown to man:

```
pandoc Desktop/launch.1.md -s -t man -o  Desktop/launch.1
/usr/bin/man ~/Desktop/launch.1
```

To convert man to txt:

```
/usr/bin/man ~/Desktop/launch.1 | col -b > ~/Desktop/launch.txt
```
