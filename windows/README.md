## Git for Windows

> Don't forget to add to your PATH - `C:\Program Files\Git\bin` - to use `bash` from the Console

When using the Git for Windows Shell / MinTTY.

- Use `.bash_profile ` with below to use general `/bashrc` files
```
if [ -f ~/.bashrc ]
then
    . ~/.bashrc
fi
```

> rsync support based on https://blog.tiger-workshop.com/add-rsync-to-git-bash-for-windows/

- Copy `rsync.exe` to `C:\Program Files\Git\usr\bin` 

## Docker

- Download from https://store.docker.com/editions/community/docker-ce-desktop-windows
- General > Enable: Expose daemon on tcp://localhost:2375 without TLS
    - Append host on each command. eg: `docker -H tcp://0.0.0.0:2375 images`
    - Or, update `~/.bashrc` with: `export DOCKER_HOST='tcp://0.0.0.0:2375'`
- Shared Drives > Enable C Drive as shared
    - CMD: Use `%CD%` for working directory
    - PowerShell: Use `$PWD` like on Linux
- Enable H-visor
    - Powershell: `Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All`
    - https://stackoverflow.com/questions/39684974/docker-for-windows-error-hardware-assisted-virtualization-and-data-execution-p
        - Powershell: `dism.exe /Online /Enable-Feature:Microsoft-Hyper-V /All`
        - Powershell: `bcdedit /set hypervisorlaunchtype auto`
- Sharing Issues
    - https://docs.docker.com/docker-for-windows/#firewall-rules-for-shared-drives
    - Powershell: `Set-NetConnectionProfile -interfacealias "vEthernet (DockerNAT)" -NetworkCategory Private`
- Test Commands
    - https://stackoverflow.com/questions/41485217/mount-current-directory-as-a-volume-in-docker-on-windows-10
    - CMD: `docker run -v %cd%:/data/git -w /data/git --rm -it ubuntu ls -la`
    - Powershell: ``docker run -v ${PWD}:/data/git -w /data/git --rm -it ubuntu ls -la`
    - Powershell / Unix: `docker run -v ${pwd}:/data/git -w /data/git --rm -it ubuntu ls -la`
    - Powershell / Unix: `docker run -v ${pwd}:/data/git --rm -it ubuntu ls -la /data/git`


## Python

> Don't forget to add to your PATH - `C:\Python27`


Install one of the below
 
- Python - https://www.python.org/downloads/windows/
- Anaconda - https://www.anaconda.com/download/


## NodeJS & NVM

- Windows - https://github.com/coreybutler/nvm-windows
    - https://github.com/coreybutler/nvm-windows/releases
- Ubuntu - https://github.com/creationix/nvm

## SSH

- https://github.com/PowerShell/Win32-OpenSSH/releases
- https://github.com/PowerShell/Win32-OpenSSH/wiki/Install-Win32-OpenSSH

- Download
    - Extract `OpenSSH-Win64.zip` to `C:\Program Files\OpenSSH`
- Install
    - `powershell.exe -ExecutionPolicy Bypass -File install-sshd.ps1`
- Update Firewall
    - `New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH SSH Server' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22`
    - `Control Panel > System and Security > Windows Firewall1 > Advanced Settings > Inbound Rules` and add a new rule for port 22.
- Start the service and/or configure automatic start:
    - Go to `Control Panel > System and Security > Administrative Tools` and open `Services`. Locate `OpenSSH SSH Server` service.
    - If you want the server to start automatically when your machine is started: Go to `Action > Properties`. In the Properties dialog, change Startup type to Automatic and confirm.
    - Start the `OpenSSH SSH Server` service by clicking the Start the service

## Bash

- Change prompt - `~/.bashrc` - `PS1='[\u@\h \W]\$ '`
- Remove console beep - `sudo vi /etc/inputrc` - add `set bell-style none`
    - See https://github.com/Microsoft/BashOnWindows/issues/715#issuecomment-238010146

## Display auto-brightness

- Launch `regedit`
- Search for `"FeatureTestControl"=dword:00009240`
    - Replace 9240 with 9250 and reboot.
    - Example: `Computer\HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0001`
    
## PATH

Windows `PATH` That includes Docker, Git, node.js/npm, SSH, Anaconda, Android, Android JRE, Vagrant, VS COde, and Ruby

```
C:\Program Files\Docker\Docker\Resources\bin;
C:\WINDOWS\system32;
C:\WINDOWS;
C:\WINDOWS\System32\Wbem;
C:\WINDOWS\System32\WindowsPowerShell\v1.0\;
C:\Program Files\Microsoft VS Code\bin;
C:\Program Files\Git\cmd;
C:\Program Files\nodejs\;
C:\WINDOWS\System32\OpenSSH\;
C:\ProgramData\Anaconda2;
C:\ProgramData\Anaconda2\Scripts;
C:\HashiCorp\Vagrant\bin;
C:\Users\nikkh\AppData\Local\Android\Sdk\platform-tools;
C:\Users\nikkh\AppData\Local\Android\Sdk\tools\bin;
C:\Users\nikkh\AppData\Local\Android\Sdk\emulator;
C:\Program Files\Android\Android Studio\jre\bin;
C:\Ruby25-x64\bin;
C:\Users\nikkh\AppData\Local\Microsoft\WindowsApps;
C:\Users\nikkh\AppData\Roaming\npm
```

## Links

- https://hub.docker.com/u/khilnani/
- https://forums.windowscentral.com/microsoft-surface-book/416121-auto-brightness-off-screen-still-dims.html
