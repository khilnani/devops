## docker

- General > Enable: Expose daemon on tcp://localhost:2375 without TLS
    - Append host on each command. eg: `docker -H tcp://0.0.0.0:2375 images`
    - Or, update `~/.bashrc` with: `export DOCKER_HOST='tcp://0.0.0.0:2375'`
- Shared Drives > Enable C Drive as shared
    - CMD: Use `%CD%` for working directory
    - PowerShell: Use `$PWD` like on Linux

## Git for Windows

> When using the Git for Windows Shell / MinTTY.

- Use `.bash_profile ` with below to use general `/bashrc` files
```
if [ -f ~/.bashrc ]
then
    . ~/.bashrc
fi
```

## Bash

- Change prompt - `~/.bashrc` - `PS1='[\u@\h \W]\$ '`
- Remove console beep - `sudo vi /etc/inputrc` - add `set bell-style none`
    - See https://github.com/Microsoft/BashOnWindows/issues/715#issuecomment-238010146

## Display auto-brightness

- Launch `regedit`
- Search for `"FeatureTestControl"=dword:00009240`
    - Replace 9240 with 9250 and reboot.
    - Example: `Computer\HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0001`

## Links

- https://hub.docker.com/u/khilnani/
- https://forums.windowscentral.com/microsoft-surface-book/416121-auto-brightness-off-screen-still-dims.html
