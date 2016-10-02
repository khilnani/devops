#!/bin/sh -x

# http://www.scala-sbt.org/release/docs/Getting-Started/Setup.html
# Mac: sudo port install sbt

VER=0.13.0

curl -O http://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/$VER/sbt-launch.jar 
sudo mv -f sbt-launch.jar /opt/local/bin/
sudo cp -f sbt /opt/local/bin
sudo chmod u+x /opt/local/bin/sbt
sbt


