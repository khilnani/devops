devops
=========

All files are copyright their respective owners. My devops files are free to use provided you say thanks.

> NOTE: Update `env/provision.sh` with your git username and email before running `vagrant up`

Each directory has it's own Readme with additional details.

- **android/** - Android Termux and Pydroid3 setup
- **anaconda3/** - Anaconda setup on Ubuntu 18.04 with Jupyter and Supervisor
- **ansible/**
  - Installer script fo Mac OS X and Linux/CentOS
  - Ansible playbook with reuseable roles for centos, nodejs, httpd, mongodb, mysql, redis, memcached, git etc.
  - Contains a test Vagrant setup for testing. Simply run `vagrant up` in the directory.
- **automation/**
  - PhantomJS based UI automation framework.
- **centos/** - CentOS 6.5 setup scripts
  - Vagrant VM/Box/Package setup for VirtualBox CentOS image
  - Chrome 28 installer (from http://chrome.richardlloyd.org.uk)
- **chromebook/**
  - Chromebook Ubuntu install notes based on Crouton.
  - MySQL, Apache2, Mongodb installer script.
- **scripts/**
  - Ubuntu install scripts not yet migrated to Ansible. Bash is better?
- **vagrant-ansible/**
  - A sample setup of Vagrant and Ansible to setup a CentOS 7 and Ubuntu 14
