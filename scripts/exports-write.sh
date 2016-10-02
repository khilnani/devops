#!/bin/bash -x

echo "export JAVA_HOME=$JAVA_HOME" >> ~/.bashrc
echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> ~/.bashrc

echo "export SCALA_HOME=$SCALA_HOME" >> ~/.bashrc
echo "export PATH=\$SCALA_HOME/bin:\$PATH" >> ~/.bashrc

echo "export KAFKA_HOME=$KAFKA_HOME" >> ~/.bashrc
echo "export PATH=\$KAFKA_HOME/bin:\$PATH" >> ~/.bashrc

echo "export HADOOP_HOME=$HADOOP_HOME" >> ~/.bashrc
echo "export PATH=\$HADOOP_HOME/bin:\$PATH" >> ~/.bashrc

echo "export SPARK_HOME=$SPARK_HOME" >> ~/.bashrc
echo "export PATH=\$SPARK_HOME/bin:\$PATH" >> ~/.bashrc

echo "export ANACONDA_HOME=$ANACONDA_HOME" >> ~/.bashrc
echo "export PATH=\$ANACONDA_HOME/bin:\$PATH" >> ~/.bashrc


echo "source \$ANACONDA_HOME/bin/activate \$ANACONDA_HOME/" >> ~/.bashrc
## echo "source ~/.rvm/scripts/rvm" >> ~/.bashrc

