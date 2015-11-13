

## Install Puppet Server

- Security group
```
TCP 8140 - Agents will talk to the master on this port
TCP 22 - To login to the server/instance using SSH
TCP 80 - HTTP
```
- `sudo hostname puppet`
- `/etc/hosts`
```
127.0.0.1   puppet ip-XXX-XX-X-XXX
127.0.0.1   localhost   localhost.localdomain
MASTERIP    puppet.ec2.internal     puppet
AGENTIP     puppetagent.ec2.internal        puppetagent
```
- `/etc/init.d/network restart`
- `sudo yum -y install puppet-server` - Install puppet server
- `sudo chkconfig puppetmaster on` - Start on boot
- `sudo service puppetmaster start` - Start
- `sudo puppet cert list` - List certs
- `sudo puppet cert sign ip-XXX-XX-X-XXX.ec2.internal` - Sign agent


## Install Puppet Agent

```
TCP 8140 - Agents will talk to the master on this port
TCP 22 - To login to the server/instance using SSH
TCP 80 - HTTP
```
- `sudo hostname puppetagent`
- `/etc/hosts`
```
127.0.0.1   puppetagent ip-XXX-XX-X-XXX
127.0.0.1   localhost   localhost.localdomain
MASTERIP    puppet.ec2.internal     puppet
AGENTIP     puppetagent.ec2.internal        puppetagent
```
- `/etc/init.d/network restart`
- `sudo yum -y install puppet` - Install puppet agent
- `sudo chkconfig puppet on` - Start on boot
- `sudo service puppet start` - Start
- `hostname -f` - fqdn adress
- `hostname -i` - ip address
- `sudo puppet agent --test` - Test connection to master

## Helloworld

On the master

- Copy `manifests/site.pp` to `/etc/puppet/manifests/`

On the agent (or master)

- If Puppet daemon is running `sudo puppet agent -t --verbose`, 
  - Else `sudo puppet agent --server puppet` or `sudo puppet agent`
- `vi /tmp/hello`

## Commands

- Apply
- `sudo puppet apply --modulepath ./modules manifests/site.pp --verbose`
Daemon
- `sudo puppet agent -t --verbose`
Standalone
- `sudo puppet agent --verbose`
- `sudo puppet agent --server puppet`


## Misc

- Edit `/etc/puppet/puppet.conf`
- View `/etc/resolv.conf`
- Edit `vi /etc/sysconfig/network`
- Restart `/etc/init.d/network restart`
