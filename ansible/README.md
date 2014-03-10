## github.com/hilnani/devops/ansible

This setup is configured to log into a VM that has been setup for Vagrant. 
i.e. has a user vagrant/vagrant and has the vagrant insecure public key setup in the `.ssh/authorized_keys`

However, the `roles` can be reused as part of any setup when symlinked.
Please change the remote user in `inventory` line `remote_user: vagrant` 

## Prerequisites

- ENsure Ansible 1.4 is installed
- Please review http://docs.ansible.com/playbooks_best_practices.html

## Specifics

- `playbook.yml` - remote_user is set to 'vagrant'
- `inventory` - ssh key config points to vagrant keys - `ansible_ssh_private_key_file=../vagrant/ssh/vagrant`

## To Run

- Edit the files in `group_vars` and `host_vars` if using includes roles.
- `ping.sh` - Sends a ping command to the VM without using a playbook
- `check.sh` - Sends the `playbook.yml` in dry run mode - No changes made on the remote server.
- `play.sh` - Runs `playbook.yml`


## Setup Steps Used

- Create SSH keys - `ssh-keygen -t rsa -C "your_email@somedomain.com"`
- Copy SSH Keys to server
  - Linux host - `ssh-copy-id -i ~/.ssh/id_rsa.pub root@1.2.3.4`
  - Mac OS X
    - `cat ~/.ssh/id_rsa.pub | ssh root@1.2.3.4 "mkdir ~/.ssh; cat >> ~/.ssh/authorized_keys"`
    - `cat ~/.ssh/id_rsa.pub | ssh root@1.2.3.4 "cat >> ~/.ssh/authorized_keys"`
- Create inventory file - See http://www.ansibleworks.com/docs/intro_inventory.html
- Test - `ansible all -m ping -i inventory -vvvv`
