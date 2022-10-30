#!/usr/bin/env bash
# refs:
# 1. https://stackoverflow.com/questions/11097761/is-there-a-way-to-make-bash-job-control-quiet
#--begin-- input region
network=192.168.71
#--end-- inut region

# one: for run in shell script 
for i in {2..254} ; do ( echo "$network.$i: `nc -w 2 $network.$i  22`" & ) done

# then check you console, open ssh server will response something
