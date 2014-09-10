#!/system/bin/sh -x

mkdir ~/bin
cd ~/bin
curl -O -k https://raw.githubusercontent.com/khilnani/devops/master/android/py
chmod 755 ~/bin/py

echo "export PATH=$PATH:~/bin:/data/data/com.nullient.angoide/files/go/bin" >> ~/.bashrc
echo "export GOROOT=/data/data/com.nullient.angoide/files/go" >> ~/.bashrc
echo "export GOPATH=~/sdcard/Go" >> ~/.bashrc
echo "export TMP=~/tmp" >> ~/.bashrc
echo "export TEMP=~/tmp" >> ~/.bashrc
source ~/.bashrc

cd ~/sdcard/Download
curl -O -k http://android-scripting.googlecode.com/files/sl4a_r6.apk
curl -O -k https://python-for-android.googlecode.com/files/PythonForAndroid_r5.apk
