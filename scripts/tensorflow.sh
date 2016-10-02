#!/bin/bash -x

# https://www.tensorflow.org/versions/r0.9/get_started/os_setup.html#anaconda-installation
# Check linux version - `uname -a`

echo '## Install TensorFlow'

pip install --upgrade --ignore-installed setuptools
pip install --upgrade $TF_BINARY_URL

python -c "import tensorflow; print(tensorflow.__version__);"

