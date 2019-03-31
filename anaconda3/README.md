# Docker

## Build

- `docker build -t anaconda3 .`
- `docker push anaconda3`
- `VER=0.0.1 docker tag  khilnani/anaconda3:latest khilnani/anaconda3:$VER && docker push khilnani/anaconda3:$VER`
- `docker run -t -i --name test_anaconda3 --privileged -v ${PWD}:/data/git --rm khilnani/anaconda3`

## Run

> On Windows 10 use Powershell in Admin mode

- `docker-compose up -d`
- `docker-compose-ssh.bat` or `docker-compose-ssh.sh`

# Conda (Python3)

> Use hvm-ssd/ubuntu-bionic-18.04

## Setup



- `./ubuntu-setup.sh`
- `./anaconda3-install.sh`
- `./conda-setup.sh`

## Config

- `conda config --add channels conda-forge`
- `conda update --all`
- `conda install --yes m2-base` - Unix tools in Windows

## Conda Environments

> https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html

List Environments

- `conda env list`
- `conda activate myenv`
- `conda deactivate`

Activate the environment where you want to put the program:

- On Windows, in your Anaconda Prompt, run `activate myenv`.
- On macOS and Linux,in your Terminal window, run `source activate myenv`.

Environment file

> Includes pip

- Export - `conda env export -f ./provision/environment.yml`
- Import - `conda env update -f ./provision/environment.yml`


Identical Envs

> Excludes pip

- Export - `conda list --explicit > spec-file-txt`
- New - `conda create --name myenv --file spec-file.txt`
- Update - `conda install --name myenv --file spec-file.txt`

# Python

- `apt-get -y install python3-pip python3-dev python3-setuptools python3.4-venv --upgrade`
- `easy_install3 pip`
- `pip3 install virtualenv`
- `python3 -m venv env` OR `virtualenv -p python3.4 env`
- `source ./env/activate`

# Jupyter

- `./jupyter-start.sh`

OR

- `./jupyter-config.sh`
- Edit: `~/.jupyter/jupyter_notebook_config.py`
```
c.NotebookApp.ip = '0.0.0.0'
c.NotebookApp.open_browser = False
# from notebook.auth import passwd; passwd()
c.NotebookApp.password = u'sha1:??:??'
c.NotebookApp.port = 8888
c.FileContentsManager.root_dir = u'/home/ubuntu/BASE_DIR'
```
- `./jupter-config-start.sh` or`./jupyter-supervisor.sh`

