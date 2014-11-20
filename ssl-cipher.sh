#!/bin/bash



ILFILE=$1
PORT=$2
#SSLCIPHER=`which ssl-cipher-suite-enum.pl`
SSLSCAN=`which sslscan`

BOLD="\033[1m"
RESET="\033[0m"
GREEN="\033[0;92m"
RED="\033[1;31m"
ORANGE="\033[1;33m"
BLINK="\033[5m"

for ip in $(cat $ILFILE)
do 
#echo -e "$GREEN ssl-cipher against $ip $RESET"
#$SSLCIPHER $ip --outfile $ip.sslcipher
echo -e "$GREEN ssl-scan against $ip $RESET"
$SSLSCAN --no-failed $ip:$PORT > $ip.$PORT.sslscan

done
