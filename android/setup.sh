#!/system/bin/sh

mkdir ~/bin
cd ~/bin
curl -O -k https://raw.githubusercontent.com/khilnani/devops/master/android/py
chmod 755 ~/bin/py
echo "export PATH=$PATH:~/bin" >> ~/.bashrc
