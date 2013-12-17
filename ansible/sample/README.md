
### General Instructions

- See `setup.md`
 
### Notes on the Sample Setup

Th sample setup is configured to log into a VM that has been setup for Vagrant. 
i.e. has a user vagrant/vagrant and has the vagrant insecure public key setup in the `.ssh/authorized_keys`

Specifics

- `playbook.yml` - remote_user is set to 'vagrant'
- `ansible_vagrant_inventory` - ssh key config points to vagrant keys - `ansible_ssh_private_key_file=../../vagrant/ssh/vagrant`

To Run

- `ping.sh` - Sends a ping command to the VM without using a playbook
- `play.sh` - Runs `playbook.yml`
