#!/bin/bash
# by n0b1dy
# script to launch nikto , hoppy and some simple web app checks against a targets file with ips

RED="\e[0;31m"
GREEN="\e[0;32m"
YELLOW="\e[0;33m"
BLUE="\e[0;34m"
PURPLE="\e[0;35m"
HPURPLE="\e[1;35m"
IRED="\e[0;91m"
IGREEN="\e[0;92m"
IYELLOW="\e[0;93m"
IBLUE="\e[0;94m"
GREEN="\e[1;32m"
BRED="\e[1;31m"
BLUE="\e[1;34m"
BGREEN="\e[1;32m"
BOLD="\e[1m"
RESET="\e[0m"


msg()     { echo -e "${BOLD}[*]${RESET} ${@}"; }
msgline() { echo -e "${BOLD}[*] `perl -e 'print "-"x50'`${RESET}"; }
msgbox()  { msgline; echo -e "${BOLD}[*]${RESET} ${@}"; msgline; }

usage() { echo -e "${BOLD}${BBLUE}\t[*] ${@}${RESET}"; }

success() { echo -e "${BOLD}${BGREEN}[SUCCESS]${RESET} ${@}"; }
error()   { echo -e "${BOLD}${BRED}[ERROR]${RESET} ${@}"; }
info()     { echo -e "${BOLD}${BLUE}[INFO]${RESET} ${@}"; }



if [ $# -eq 0 ]; then
usage "Script to run nikto and hoppy and save the results as ip.port.nikto and hoppy."
usage "$0 <targetfile> <portfile>"
exit
fi


targets=$1
ports=$2
NIKTOSCAN=`which nikto`
HOPPYSCAN="/root/tools/labs/hoppy-1.8.1/hoppy"


start=`date` #start counting time

for ip in $(cat $targets)
do 
  for port in $(cat $ports)
  do 
  success " Running nikto against ${BOLD}${BGREEN}$ip${RESET} and ${BOLD}${BGREEN}$port${RESET} port "
  $NIKTOSCAN -h $ip -p $port -o $ip.$port.nikto.txt
  success " Running hoppy against ${BOLD}${BGREEN}$ip${RESET} and ${BOLD}${BGREEN}$port${RESET} port "
  $HOPPYSCAN -h https://$ip:$port/ -S $ip.$port.hoppy
  done
done

end=`date` 
success "Web checks finished.[$end]"


