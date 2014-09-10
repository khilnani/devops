#!/system/bin/sh

mkdir ~/bin
cd ~/bin
curl -O -k https://raw.githubusercontent.com/khilnani/devops/master/android/py
chmod 755 ~/bin/py
echo "export PATH=$PATH:~/bin" >> ~/.bashrc
cd ~/sdcard/Download
curl -O -k http://android-scripting.googlecode.com/files/sl4a_r6.apk
curl -O -k https://python-for-android.googlecode.com/files/PythonForAndroid_r5.apk
