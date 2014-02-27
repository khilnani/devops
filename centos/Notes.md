## User Management

### Add User

### Passwords

- `sudo passwd USER`

### SSH

- Edit `/etc/ssh/sshd_config` (on Mac `/etc/sshd_config`)
- Allow Password - `PasswordAuthentication yes`
- Secure
  - `Protocol 2`
  - `ClientAliveInterval 300`
  - `ClientAliveCountMax 0`
  - `PermitRootLogin no`
  - `PermitEmptyPasswords no`
- Restart service - `sudo service sshd restart`

### File Locations

sudo cat /etc/sudoers
sudo cat /etc/passwd
sudo cat /etc/shadow

## Node.js

### From the source


- yum install gcc-c++ make git
- cd /usr/local/src/
- git clone git://github.com/joyent/node.git
- cd node
- ./configure
- make
- make install

### From an archive

- su - 
- yum install openssl-devel
- cd /usr/local/src
- wget http://nodejs.org/dist/v0.8.15/node-v0.8.15.tar.gz
- tar zxvf node-v0.8.15.tar.gz
- cd node-v0.8.15
- ./configure
- make
- make install



