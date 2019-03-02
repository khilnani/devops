# Conda (Python3)

> Use hvm-ssd/ubuntu-bionic-18.04-amd64-server-20180912 (ami-0ac019f4fcb7cb7e6)

## Setup

- `./ubuntu.sh`
- `./anaconda3.sh`
- `./conda.sh`

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
- `source ./env/activate
