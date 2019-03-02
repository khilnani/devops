#!/bin/sh -x


conda env export -f anaconda3-ubuntu-`lsb_release -r -s`.yml
