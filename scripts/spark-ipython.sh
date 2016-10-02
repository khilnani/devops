#!/bin/bash -x

############################################
# Check versions
############################################

$SPARK_HOME/bin/pyspark --version
$ANACONDA_HOME/bin/ipython --version
$ANACONDA_HOME/bin/jupyter --version

############################################
# ipython setup
############################################

$ANACONDA_HOME/bin/ipython profile create pyspark
cat >~/.ipython/profile_pyspark/startup/00-spark-setup.py <<EOL

import os
import sys

spark_home = os.environ.get('SPARK_HOME', None)
sys.path.insert(0, os.path.join(spark_home, 'python'))
sys.path.insert(0, os.path.join(spark_home, 'python/lib/py4j-0.10.1-src.zip'))
execfile(os.path.join(spark_home, 'python/pyspark/shell.py'))

EOL

############################################
# test
############################################

#ipython --profile=pyspark
#sc

############################################
# Setup Pyspark and Jupyter
############################################

mkdir -p ~/.ipython/kernels/spark

cat >~/.ipython/kernels/spark/kernel.json <<EOL
{
    "display_name": "PySpark (Spark 2.0.0)",
    "language": "python",
    "argv": [
        "python",
        "-m",
        "ipykernel",
        "--profile=pyspark",
        "-f",
        "{connection_file}"
    ]
}
EOL

# pip install py4j
# export PYSPARK_SUBMIT_ARGS="--master spark://127.0.0.1:7077 pyspark-shell"
# OR
#
# {
#     "display_name": "PySpark (Spark 2.0.0)",
#     "language": "python",
#     "argv": [
#         "python",
#         "-m",
#         "ipykernel",
#         "--profile=pyspark",
#         "-f",
#         "{connection_file}"
#     ]
#     ,"env": {
#     	"SPARK_HOME": "<spark_dir>",
#     	"PYSPARK_SUBMIT_ARGS": "--master spark://127.0.0.1:7077 pyspark-shell"
#     }
# }




# touch ~/.ipython/kernels/pyspark/kernel.json
# {
#  "display_name": "pySpark (Spark 1.4.0)",
#  "language": "python",
#  "argv": [
#   "/usr/bin/python2",
#   "-m",
#   "IPython.kernel",
#   "-f",
#   "{connection_file}"
#  ],
#  "env": {
#   "SPARK_HOME": "<spark_dir>",
#   "PYTHONPATH": "<spark_dir>/python/:<spark_dir>/python/lib/py4j-0.8.2.1-src.zip",
#   "PYTHONSTARTUP": "<spark_dir>/python/pyspark/shell.py",
#   "PYSPARK_SUBMIT_ARGS": "--master spark://127.0.0.1:7077 pyspark-shell"
#  }
# }

# ipython console --kernel pyspark
