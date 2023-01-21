#!/bin/bash
set -x

################################################################################
# File:    buildDocs.sh
# Purpose: Script that builds our documentation using sphinx and updates GitHub
#          Pages. This script is executed by:
#            .github/workflows/docs_pages_workflow.yml
#
# Authors: Michael Altfield <michael@michaelaltfield.net>
# Created: 2020-07-17
# Updated: 2020-07-17, further modified by probono
# Version: 0.1, modified by probono
################################################################################
 
###################
# INSTALL DEPENDS #
###################
 
apt-get update
apt-get -y install git rsync python3-pip # qttools5-dev-tools qt5-default qt5-qmake
pip3 install setuptools wheel
pip3 install docutils==0.16 sphinx sphinx-autobuild sphinx-rtd-theme commonmark recommonmark sphinx-markdown-tables markdown!=3.3.5 # sphinxcontrib-qthelp
# markdown!=3.3.5 = Workaround for ryanfox/sphinx-markdown-tables#34

#####################
# DECLARE VARIABLES #
#####################
 
pwd
ls -lah
export SOURCE_DATE_EPOCH=$(git log -1 --pretty=%ct)
 
##############
# BUILD DOCS #
##############
 
# build our documentation with sphinx (see ./conf.py)
# * https://www.sphinx-doc.org/en/master/usage/quickstart.html#running-the-build
make clean
make html
make epub
make qthelp
qcollectiongenerator _build/qthelp/*.qhcp
# sphinx-build -b html . _build
# make -C ./docs html

#####################################
# Upload outputs to GitHub Releases #
#####################################

rm -rf ./out/ || true
mkdir -p out
cp _build/qthelp/*.qhc _build/epub/*.epub out/
wget "https://github.com/tcnksm/ghr/releases/download/v0.13.0/ghr_v0.13.0_linux_amd64.tar.gz"
tar xf ghr_*.tar.gz
GH_USER=$(echo "${GITHUB_REPOSITORY}" | cut -d "/" -f 1)
GH_REPO=$(echo "${GITHUB_REPOSITORY}" | cut -d "/" -f 2)
./ghr_*/ghr -delete -t "${G_TOKEN}" -u "${GH_USER}" -r "${GH_REPO}" -c "${GITHUB_SHA}" continuous out/
 
#######################
# Update GitHub Pages #
#######################

printenv

git config --global user.name "${GITHUB_ACTOR}"
git config --global user.email "${GITHUB_ACTOR}@users.noreply.github.com"
  
docroot=`mktemp -d`
rsync -av "./_build/html/" "${docroot}/"
 
pushd "${docroot}"
 
# don't bother maintaining history; just generate fresh
git init
git remote add deploy "https://token:${G_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
git checkout -b gh-pages
 
# add .nojekyll to the root so that github won't 404 on content added to dirs
# that start with an underscore (_), such as our "_content" dir..
touch .nojekyll
 
# Add README
cat > README.md <<EOF
# GitHub Pages Cache
 
Nothing to see here. The contents of this branch are essentially a cache that's not intended to be viewed on github.com.
 
For more information on how this documentation is built using Sphinx, Read the Docs, and GitHub Actions/Pages, see another branch in this repository.
EOF
 
# copy the resulting html pages built from sphinx above to our new git repo
git add .
 
# commit all the new files
msg="Updating Docs for commit ${GITHUB_SHA} made on `date -d"@${SOURCE_DATE_EPOCH}" --iso-8601=seconds` from ${GITHUB_REF} by ${GITHUB_ACTOR}"
git commit -am "${msg}"
 
# overwrite the contents of the gh-pages branch on our github.com repo
git push deploy gh-pages --force
 
popd # return to main repo sandbox root
 
# exit cleanly
exit 0
EEOOFF
