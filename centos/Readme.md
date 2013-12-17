
## CentOS Setup Scripts

This section contains scripts to setup CentOS 6.5 images in Virtual Box

## Generic VM Setup

- Run `centos-core.sh`
- Run `centos-tools.sh` for additional Develper packages

## Vagrant VM

### General Steps

#### Create Virtual Box VM

- Install Virtual Box from https://www.virtualbox.org/
- Download the CentOS 6.5 i386 Disc 1 ISO from http://mirror.umd.edu/centos/6.5/isos/i386/CentOS-6.5-i386-bin-DVD1.iso
- Setup a new VM in Virtual Box
  - root password: vagrant
- Execute `centos-vagrant-setup.sh` on the VM once CentOS is installed

#### Create Vagrant Box

- Download and install Vagrant from http://www.vagrantup.com/downloads.html
- Export Vagrant box, run `vagrant package --base NAME`
- Rename `package.box` to `NAME.box`
- Init Vagrant with the box `vagrant init ID NAME.box`
- Edit Vagrant File for GUI access if desired
```
config.vm.provider "virtualbox" do |v|
  v.gui = true
end
```
- Start Vagrant `vagrant up`
- If `vagrant up` hangs while waiting for VM to boot. 
  - Ctrl-C and try `vagrant ssh`
  - If that works, 
    - Enable gui (see above)
    - Login in to the guest VM as `root`
    - Execute `sudo rm -Rf /var/lib/dhclient/*`
    - Run `/sbin/shutdown -h now`
  - Restart the Vagrant VM
    - `vagrant reload`
  - If that does not fix the hang, ensure ssh keys have been setup correctly
- To Debug
  - `VAGRANT_LOG=info vagrant up`
  - `vagrant up --debug`
  - Imported boxes are stored at `~/.vagrant.d`

### Links

- http://docs.vagrantup.com/v2/virtualbox/boxes.html


