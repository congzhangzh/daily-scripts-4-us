#!/usr/bin/env bash

#--begin-- input region
network=192.168.1
#--end-- inut region

for i in {2..254} ; do echo $network.$i ; nc -w 2 $network.$i ; done

# then check you console, open ssh server will response something
