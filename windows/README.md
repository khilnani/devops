## docker

- General > Enable: Expose daemon on tcp://localhost:2375 without TLS
    - Append host on each command. eg: `docker -H tcp://0.0.0.0:2375 images`
    - Or, update `~/.bashrc` with: `export DOCKER_HOST='tcp://0.0.0.0:2375'`
- Shared Drives > Enable C Drive as shared
    - CMD: Use `%CD%` for working directory
    - PowerShell: Use `$PWD` like on Linux

## Bash

- Change prompt - `~/.bashrc` - `PS1='[\u@\h \W]\$ '`
- Remove console beep - `sudo vi /etc/inputrc` - add `set bell-style none`
    - See https://github.com/Microsoft/BashOnWindows/issues/715#issuecomment-238010146

## Links

- https://hub.docker.com/u/khilnani/
