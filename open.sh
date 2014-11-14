#!/bin/bash
# by n0b1dy
# get as an input .nmap scan and gives the uniq open ports that are open
cat $1 | grep "open" | cut -d/ -f1 | grep -v "Warning" | sort -n | uniq > scan.tcp.open
