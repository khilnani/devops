> A sample setup of Vagrant and Ansible to setup a CentOS 6.5 and Ubuntu 12.04 LTS

- Install
  - Vagrant - http://www.vagrantup.com/
    - For Centos folder mounts, run: ` vagrant plugin install vagrant-vbguest`
  - Virtualbox - https://www.virtualbox.org/
  - Ansible - http://docs.ansible.com/intro_installation.html
- Download this directory 
- Execute `vagrant up` or `vagrant up centos` or `vagrant up ubuntu`
- The directory with the Vagrantfile  is mounted in the VM at `/host_data`.
