# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define "ubuntu" do |ubuntu|
    ubuntu.vm.provider "virtualbox" do |vb|
        vb.gui = false
        vb.customize ["modifyvm", :id, "--memory", "1024"]
    end
    ubuntu.vm.box = "ubuntu/trusty64"
    ubuntu.vm.hostname = "ubuntu"
    ubuntu.vm.network "forwarded_port", guest: 22, host: 1235
    ubuntu.vm.network "forwarded_port", guest: 8888, host: 8888
    ubuntu.vm.provision "shell", path: "env/provision.sh"
  end
  config.vm.synced_folder "./", "/data/git/devops/"
end
