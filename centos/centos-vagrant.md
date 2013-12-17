## Prepating Cent OS 6.5 for Vagrant

### Links

- http://docs.vagrantup.com/v2/virtualbox/boxes.html

### Steps

- Install Virtual Box
- Download the CentOS 6.5 i386 Disc 1 ISO
- Setup a new VM in Virtual Box
  - root password: vagrant
- Execute steps in `centos-vagrant.sh` on a fresh Virtial Box VM of CentOS
- Export Vagrant box `vagrant package --base NAME`
- Init Vagrant with the box `vagrant init ID NAME.box`
- Edit Vagrant File for GUI access if desired
```
config.vm.provider "virtualbox" do |v|
  v.gui = true
end
```
- Start vagrant `vagrant up`
- If `vagrant up` hangs when waiting for VM to boot. 
  - Ctrl-C and try `vagrant ssh`
  - If that works, on guest VM try `sudo rm -Rf /var/lib/dhclient/*`
  - On the host restart the vagrant vm
  - If that does not fix the hang, ensure ssh keys have been setup
- Debug
  - `VAGRANT_LOG=info vagrant up`
  - `vagrant up --debug`
  - Boxes are stored at `~/.vagrant.d`


