#!/bin/bash



ILFILE=$1
HOPPYSCAN=`which hoppy`
#SSLSCAN=`which sslscan`

BOLD="\033[1m"
RESET="\033[0m"
GREEN="\033[0;92m"
RED="\033[1;31m"
ORANGE="\033[1;33m"
BLINK="\033[5m"

for ip in $(cat $ILFILE)
do 
echo -e "$GREEN nikto against $ip $RESET"
$HOPPYSCAN -h https://$ip:443/ -S $ip.443.hoppy

done
