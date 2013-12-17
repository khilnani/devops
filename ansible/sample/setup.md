
- Create SSH keys - `ssh-keygen -t rsa -C "your_email@somedomain.com"`
- Copy SSH Keys to server
  - Linux host - `ssh-copy-id -i ~/.ssh/id_rsa.pub root@1.2.3.4`
  - Mac OS X
    - `cat ~/.ssh/id_rsa.pub | ssh root@1.2.3.4 "mkdir ~/.ssh; cat >> ~/.ssh/authorized_keys"`
    - `cat ~/.ssh/id_rsa.pub | ssh root@1.2.3.4 "cat >> ~/.ssh/authorized_keys"`
- Create inventory file - See http://www.ansibleworks.com/docs/intro_inventory.html
- Test - `ansible all -m ping -i ansible_sample_inventory -vvvv`
