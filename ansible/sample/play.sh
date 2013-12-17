#!/bin/sh -x

ansible-playbook playbook.yml -i ansible_vagrant_inventory -vvvv
