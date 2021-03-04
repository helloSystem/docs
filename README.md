# hello Documentation

This repository builds the [documentation](https://hellosystem.github.io/docs/) for hello.

It uses Sphinx, recommonmark, and GitHub Actions to produce documentation from the Markdown source files in this repository.

* https://stackoverflow.com/a/62967771
* https://recommonmark.readthedocs.io/en/latest/

## Local development server

Use a local development server that regenerates the output whenever the input changes:

```sh
sudo pkg install -y py37-pip gmake # on FreeBSD, e.g., on helloSystem
pip-3.7 install -r requirements.txt
export GITHUB_REPOSITORY="helloSystem/docs"
export PATH=~/.local/bin/:$PATH
gmake watch
```

Now open http://127.0.0.1:8000 in a web browser. It will be regenerated and refreshed whenever one of the input files changes.

## Local output generation

One can also generate documentation in various output formats locally:

```sh
sudo pkg install -y py37-pip gmake # on FreeBSD, e.g., on helloSystem
pip-3.7 install -r requirements.txt
export GITHUB_REPOSITORY="helloSystem/docs"
export PATH=~/.local/bin/:$PATH
gmake html
gmake epub
gmake html
gmake qthelp
qmake # list more output formats
```
