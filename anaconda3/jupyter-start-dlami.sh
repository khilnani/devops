#!/bin/sh -x

source activate tensorflow_p36
jupyter notebook --no-browser --ip=0.0.0.0 --port=8888
