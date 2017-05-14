#!/bin/sh -x

#apt-get -y install rustc
curl https://sh.rustup.rs -sSf | sh

echo "source $HOME/.cargo/env" >> ~/.bashrc
source $HOME/.cargo/env

rustc --version
rustup --version
cargo --version
