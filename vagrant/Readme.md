## Install Vagrant Boxes

- Run `add-remote-boxes.py` to add the boxes below that I have stored in Dropbox. See 'centos' dir for details.
  - CentOS 6.5 i386 
  - CentOS 6.5 i386 with VGA
  - Ubuntu 12 i386

## 'ssh/' - Setup SSH

- Run `download-vagrant-ssh-keys.sh` to Download the Vagrant Public and Private key. Usually needed if you want to SSH in to Vagrant Box without using Vagrant - directly via ssh.
- Run `install-vagrant-ssh-pub-key.sh` to install the Vagrant public key to a Guest VM's `.ssh/authorized_keys` file
