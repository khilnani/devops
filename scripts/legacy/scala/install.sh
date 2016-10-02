#!/bin/sh -x

# See http://www.scalatra.org/2.2/getting-started/first-project.html

VER=2.11.7

curl -O http://www.scala-lang.org/files/archive/scala-$VER.tgz
gzip -dc scala-$VER.tgz | tar xf -
sudo mv -f scala-$VER /opt/local/bin/
sudo ln -sf /opt/local/bin/scala-$VER/bin/fsc /opt/local/bin/fsc
sudo ln -sf /opt/local/bin/scala-$VER/bin/scala /opt/local/bin/scala
sudo ln -sf /opt/local/bin/scala-$VER/bin/scalac /opt/local/bin/scalac
sudo ln -sf /opt/local/bin/scala-$VER/bin/scalap /opt/local/bin/scalap
sudo ln -sf /opt/local/bin/scala-$VER/bin/scaladoc /opt/local/bin/scaladoc
rm -rf scala-$VER
rm scala-$VER.tgz
scala -version

