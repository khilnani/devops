#!/bin/sh -x

ansible all -m ping -i ansible_vagrant_inventory -vvvv
