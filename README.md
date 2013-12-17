devops
=========

All files are copyright their respective owners.

My devops files are free to use provided you say thanks.

- **centos/** - CentOS 6.5 setup scripts
  - CLI, GUI, common tools
  - Vagrant VM/Box/Package setup for VirtualBox CentOS image
  - Chrome 28 installer (from http://chrome.richardlloyd.org.uk)
- **vagrant/** - Vagrant Boxes
  - Run `add-remote-boxes.py` to install the Vagrant Boxes below
    - CentOS 6.5 i386 (see 'centos' dir for details)
    - Ubuntu 12 i386 
  - *ssh/*
    - `download-vagrant-ssh-keys.sh` - Download the public vagrant keys
    - `install-vagrant-ssh-pub-key.sh` Install the Vagrant insecure public key to authorized keys
- **ansible/**
  - `install-ansible.py` - Installer script fo Mac OS X and Linux/CentOS
  - *sample/*
    - Simple reference setup of an Ansible playbook with instructions
