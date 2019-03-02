#!/usr/bin/env bash

cp jupyter-supervisor.conf /etc/supervisor/conf.d/jupyter.conf

systemctl enable supervisor
systemctl start supervisor


