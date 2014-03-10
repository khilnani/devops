#!/bin/sh -x

ansible all -m ping -i inventory -vvvv
