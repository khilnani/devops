#!/bin/bash -x

############################################
CWD=`pwd`
cd /tmp/
############################################

############################################
# Spark
############################################

wget "http://mirror.cc.columbia.edu/pub/software/apache/spark/spark-$SPARK_VERSION/$SPARK_FILE.tgz"
tar xvf "$SPARK_FILE.tgz"
rm "$SPARK_FILE.tgz"
sudo mv "$SPARK_FILE" $SPARK_INSTALL_DIR

#cd $SPARK_HOME
#./bin/run-example SparkPi 10
#./bin/spark-submit examples/src/main/python/pi.py 10


############################################
cd $CWD
############################################
