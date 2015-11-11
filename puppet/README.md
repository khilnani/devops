

# Install Puppet Server

- Security group
```
TCP 8140 - Agents will talk to the master on this port
TCP 22 - To login to the server/instance using SSH
TCP 80 - HTTP
```
- `sudo hostname puppet`
- `/etc/hosts` - `SLAVEIP  puppetslave`
- `sudo yum -y install puppet-server` - Install puppet server
- `sudo chkconfig puppetmaster on` - Start on boot
- `sudo service puppetmaster start` - Start
- `puppet cert list` - List certs


@ Install Puppet Agent

```
TCP 8140 - Agents will talk to the master on this port
TCP 22 - To login to the server/instance using SSH
TCP 80 - HTTP
```
- `sudo hostname puppetslave`
- `/etc/hosts` - `MASTERIP  puppet`
- `sudo yum -y install puppet` - Install puppet agent
- `sudo chkconfig puppet on` - Start on boot
- `sudo service puppet start` - Start
- `sudo puppet agent --test` - Test connection to master
- Edit `/etc/puppet/puppet.conf`
