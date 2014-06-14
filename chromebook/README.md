## Install Ubuntu on Chromebook

- Restart the Chromebook using `ESC-Refresh-Power`

> **The Next command will ERASE ALL DATA in your Chromebook**

- At the prompt, `CTRL-D` to erase and install ChromeOS in Developer mode
- Launch terminal - `CTRL-ALT-t`
- Download [Crouton](http://goo.gl/fd3zc) from (https://github.com/dnschneid/crouton)
- `cd ~/Downloads/`
  - CLI - `sudo sh -e crouton -r trusty -t cli-extra`
  - GUI - `sudo sh -e crouton -r trusty -t xfce`

> Use `-p "/media/removable/USB Drive/"` to install to an external drive

- Open up port 80 if needed - `sudo /sbin/iptables -A INPUT -p tcp --dport 80 -j ACCEPT`
- Turn off sleep mode - `sudo initctl stop powerd`
- Enter Linux 
  - CLI
    - Default - `sudo enter-chroot`
    - By Name - `sudo enter-chroot -n trusty`
    - From the USB Drive - `sudo enter-chroot -c /usr/local/chroots -n trusty`
  - XFE
    - Default - `sudo enter-chroot startxfce4`
    - By Name - `sudo enter-chroot -n trusty startxfce4`
    - From the USB Drive - `sudo enter-chroot -c /usr/local/chroots -n trusty startxfce4`
- In Ubuntu, run - `wget -O - http://goo.gl/XiQsTs | sudo bash` (This runs the `install-lamp-mongo.sh` script in this github directory) 
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
- MyAQL is at `/etc/mysql/my.cnf`
- Mongo DB Dir is `/data/db`
- Start Apache - `sudo service apache2 start` or `sudo /etc/init.d/apache2 start`
- Start httpd - `sudo /etc/init.d/mysql start`

## Links

- https://github.com/dnschneid/crouton/wiki
- https://help.ubuntu.com/community/ApacheMySQLPHP
- http://www.overdigital.com/2013/06/02/how-to-use-your-chromebook-pixel-as-a-webserver/
- http://tomwwolf.com/chromebook-14-compedium/chromebook-crouton-cookbook/
