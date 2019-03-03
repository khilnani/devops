#!/bin/sh -x

export PATH=/opt/anaconda3/bin:$PATH

conda config --add channels conda-forge
conda update --all

conda install --yes --file conda.txt
conda install --yes --channel "conda-forge" --file conda-forge.txt
pip -q install -r pip.txt


