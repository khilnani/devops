## Install Ubuntu on Chromebook

- Restart using `ESC-Refresh-Power`
- At the prompt, `CTRL-D` to erase and install ChromeOS in Developer mode
- Launch terminal - `CTRL-ALT-t`
- Download and Install [Crouton](http://goo.gl/fd3zc) from (https://github.com/dnschneid/crouton)
  - `sudo sh -e ~/Downloads/crouton -t cli-extra`
  - `sudo sh -e crouton -p "/media/removable/USB Drive/" -r trusty -t cli-extra`
  - `sudo sh -e crouton -p "/media/removable/USB Drive/" -r trusty -t xfce`
- Open up port 80 if needed - `sudo /sbin/iptables -A INPUT -p tcp --dport 80 -j ACCEPT`
- Turn off sleep mode - `sudo initctl stop powerd`
- Enter Linux 
  - CLI
    - `sudo enter-chroot`
    - `sudo enter-chroot -n trusty`
    - `sudo enter-chroot -c /usr/local/chroots -n trusty`
  - XFE
    - `sudo enter-chroot startxfce4`
    - `sudo enter-chroot -n trusty startxfce4`
    - `sudo enter-chroot -c /usr/local/chroots -n trusty startxfce4`
- In Ubuntu, run - `wget -O - http://goo.gl/XiQsTs | sudo bash`

## Links

- https://github.com/dnschneid/crouton/wiki
- https://help.ubuntu.com/community/ApacheMySQLPHP
- http://www.overdigital.com/2013/06/02/how-to-use-your-chromebook-pixel-as-a-webserver/
- http://tomwwolf.com/chromebook-14-compedium/chromebook-crouton-cookbook/

## Backup and Restore

- Backup - `sudo edit-chroot -f /path/to/folder -b trusty`
- Restore - `sudo edit-chroot -f /path/to/folder -r trusty`
- Install from backup - `sudo sh -e crouton -r trusty -t xfce -f /media/removable/SD\ Card/backup/trusty-20130617-1234.tar.gz`

## Notes

- You can flip through your running chroot desktops and Chromium OS by hitting `Ctrl+Alt+Shift+Back` and `Ctrl+Alt+Shift+Forward`
- You can start Xfce via the startxfce4 host command: `sudo startxfce4`
- apache is at `/etc/apache2` and `/var/www`
- php is at `/etc/php5/apache2/php.ini`
- mysql is at `/etc/mysql/my.cnf`
- Start Apache - `sudo service apache2 start` or `sudo /etc/init.d/apache2 start`
- Start httpd - `sudo /etc/init.d/mysql start`
