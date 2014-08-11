## Install Ubuntu on Chromebook

- Restart the Chromebook using `ESC-Refresh-Power`

> **The Next command will ERASE ALL DATA in your Chromebook**

- At the prompt, `CTRL-D` to erase and install ChromeOS in Developer mode
- Launch terminal - `CTRL-ALT-t`
- Download [Crouton](http://goo.gl/fd3zc) from (https://github.com/dnschneid/crouton)
- `cd ~/Downloads/`
  - XFCE - `sudo sh -e crouton -r trusty -t xfce`

> - Use `-p "/media/removable/ExtSD/crouton/"` to install to an external drive
> - Also see https://github.com/dnschneid/crouton/wiki/get-crouton-awesome.sh

- Open up port 80 if needed - `sudo /sbin/iptables -A INPUT -p tcp --dport 80 -j ACCEPT`
- Turn off sleep mode - `sudo initctl stop powerd`
- Enter Linux 
  - CLI
    - Default - `sudo enter-chroot`
    - By Name - `sudo enter-chroot -n trusty`
  - XFE
    - Default - `sudo enter-chroot startxfce4`
    - By Name - `sudo enter-chroot -n trusty startxfce4`
- In Ubuntu, run - `wget -O - http://goo.gl/XiQsTs | sudo bash`
  - This runs the `install-lamp-mongo.sh` script in this github directory
  - Installs: Chrome Browser, Ruby/Rails, NodeJS, Apache, MySQL and MongoDB
  - The script will prompt you twice - (1) for your sudo password, and (2) to set your MySQL root password.
- Logout - `exit` or Logout
- Apache, MySQL and MongoDB will be auto started when u enter Ubuntu going forward.

## Backup and Restore

- Backup - `sudo edit-chroot -f /path/to/folder -b trusty`
- Restore - `sudo edit-chroot -f /path/to/folder -r trusty`
- Install from backup - `sudo sh -e crouton -r trusty -t xfce -f /media/removable/SD\ Card/backup/trusty-20130617-1234.tar.gz`

## Notes

- Apache, MySQL and MongoDB will be auto started when u enter Ubuntu
- You can flip through your running chroot desktops and Chromium OS by hitting `Ctrl+Alt+Shift+Back` and `Ctrl+Alt+Shift+Forward`
- You can start Xfce via the startxfce4 host command: `sudo startxfce4`
- Apache is at `/etc/apache2` and `/var/www`
- Php is at `/etc/php5/apache2/php.ini`
- MySQL is at `/etc/mysql/my.cnf`
- Mongo DB Dir is `/data/db`
- Postgress Console - `sudo su - postgress -c psql`
- Start Apache - `sudo service apache2 start` or `sudo /etc/init.d/apache2 start`
- Start httpd - `sudo /etc/init.d/mysql start`
- Start Postgres - `sudo service postgresql start`

## Links

- https://github.com/dnschneid/crouton/wiki
- https://help.ubuntu.com/community/ApacheMySQLPHP
- http://www.overdigital.com/2013/06/02/how-to-use-your-chromebook-pixel-as-a-webserver/
- http://tomwwolf.com/chromebook-14-compedium/chromebook-crouton-cookbook/
- https://gorails.com/setup/ubuntu/14.04
