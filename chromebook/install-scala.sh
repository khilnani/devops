#!/bin/sh

wget http://www.scala-lang.org/files/archive/scala-2.9.1-1.tgz
tar zxf scala-2.9.1-1.tgz
sudo mv scala-2.9.1-1 /usr/share
ln -s /usr/share/scala-2.9.1-1 /usr/share/scala
 
ln -s /usr/share/scala/bin/scala /usr/bin/scala
ln -s /usr/share/scala/bin/scalac /usr/bin/scalac
ln -s /usr/share/scala/bin/fsc /usr/bin/fsc
ln -s /usr/share/scala/bin/scaladoc /usr/bin/scaladoc
ln -s /usr/share/scala/bin/scalap /usr/bin/scalap
 
wget http://scalasbt.artifactoryonline.com/scalasbt/sbt-native-packages/org/scala-sbt/sbt//0.12.3/sbt.deb
sudo dpkg -i sbt.deb
sudo apt-get update
sudo apt-get install sbt
