#!/usr/bin/env python

import os
import sys
import subprocess

if sys.platform == "darwin":
  print 'You are using a Mac. Checking for Xcode...'
  try:
    subprocess.check_output('pkgutil --pkg-info=com.apple.pkg.DeveloperToolsCLI', shell=True, stderr=subprocess.STDOUT)
  except subprocess.CalledProcessError as e:
    print ''
    print e.output
    print "Please install XCode Developer Tools first."
    sys.exit()
  else:
    print 'Xcode found.'
elif sys.platform == "linux" or sys.platform == "linux2":
  pass
  #os.system('yum -y install git-core')
else:
  print 'Your platform {} is not supported.'.format(sys.platform)
  sys.exit()

print 'Installing ansible dependencies...'

os.system('sudo easy_install pip')
os.system('sudo pip install paramiko PyYAML jinja2')

os.system('sudo pip install ansible')

#print 'Checkout ansible git project'

#os.system('git clone git://github.com/ansible/ansible.git')
#os.system('source ansible/hacking/env-setup')

