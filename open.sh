#!/bin/bash
# by n0b1dy
cat $1 | grep "open" | cut -d/ -f1 | grep -v "Warning" | sort -n | uniq > scan.tcp.open
