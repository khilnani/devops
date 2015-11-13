## Links

- Docs - https://docs.puppetlabs.com/puppet/latest/reference/
- Modules - https://docs.puppetlabs.com/puppet/latest/reference/modules_fundamentals.html

## Commands

- Apply
  - `sudo puppet apply --modulepath ./modules manifests/site.pp --verbose`
- Daemon
  - `sudo puppet agent -t --verbose`
- Standalone
  - `sudo puppet agent --verbose`
  - `sudo puppet agent --server puppet`

## Helloworld

On the master

- Copy `manifests/site.pp` to `/etc/puppet/manifests/`

On the agent (or master)

- If Puppet daemon is running `sudo puppet agent -t --verbose`, 
  - Else `sudo puppet agent --server puppet` or `sudo puppet agent`
- `vi /tmp/hello`


## Misc

- Edit `/etc/puppet/puppet.conf`
- View `/etc/resolv.conf`
- Edit `vi /etc/sysconfig/network`
- Restart `/etc/init.d/network restart`
