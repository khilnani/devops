#!/bin/sh -x

# See http://www.scalatra.org/2.2/getting-started/first-project.html

curl https://raw.github.com/n8han/conscript/master/setup.sh | sh
cat "export PATH=/Users/$USER/bin:\$PATH" >> /Users/$USER/.profile
source ~/.profile
cs n8han/giter8
g8 scalatra/scalatra-sb
chmod u+x sbt
