#!/bin/bash



ILFILE=$1
NIKTOSCAN=`which nikto`
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
$NIKTOSCAN -h $ip -p 443 -o $ip.443.nikto.txt

done
