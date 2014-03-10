#!/bin/sh
if [ "$#" -ge 2 ]; then
  ansible-playbook $1 -i inventory --check -l $2 -vv$3
else
  echo "USAGE: $0 playbook.yml all|HOST [v|vv]"
fi
