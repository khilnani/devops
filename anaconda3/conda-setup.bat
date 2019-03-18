#!/bin/sh -x

export PATH=/opt/anaconda3/bin:$PATH

call conda config --add channels conda-forge
call conda update --all

call conda install --yes --file conda-win.tx
call conda install --yes --file conda.txt
call conda install --yes --channel "conda-forge" --file conda-forge.txt
call pip -q install -r pip.txt

python -m spacy download en
