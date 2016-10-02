#!/bin/bash -x

# alt: pip install pyopenssl ndg-httpsclient pyasn1
pip install requests[security] --upgrade
pip install virtualenvwrapper
pip install pykafka
pip install kafka-python
