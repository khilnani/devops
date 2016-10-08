#!/usr/bin/env python

import os
import sys
import subprocess

installed_boxes = []
boxes = [
          {'name': 'centos-6.5',  'url': 'https://dl.dropboxusercontent.com/u/26568959/VagrantBoxes/CentOS-6.5-i386.box'},
          {'name': 'centos-6.5-gui',  'url': 'https://dl.dropboxusercontent.com/u/26568959/VagrantBoxes/CentOS-6.5-gui-i386.box'},
          {'name': 'ubuntu-12',   'url': 'https://dl.dropboxusercontent.com/u/26568959/VagrantBoxes/Ubuntu-12.04.3-i386.box'}
        ]

try:
  op = subprocess.check_output('vagrant box list', shell=True)
  if op.find('Usage:') != -1:
    print op
    sys.exit()
  installed_boxes = op.split()
except:
  print 'Unable to execute: vagrant box list'
else:
  for box in boxes:
    print('Box {} ...'.format(box['name']))
    if any( box['name'] == b for b in installed_boxes):
      print('Box {} already exists.'.format(box['name']))
    else:
      print('Adding Box {} from {}'.format(box['name'],box['url']))
      os.system('vagrant box add {} {}'.format(box['name'], box['url']))
