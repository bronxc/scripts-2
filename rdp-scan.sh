#!/bin/bash


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
usage "Script to run rdp-sec-check and save the results as ip.rdp"
usage "$0 <targetfile> "
exit
fi


targets=$1

RDPSCAN="/root/tools/labs/rdp-sec-check-0.9/rdp-sec-check.pl"

start=`date` #start counting time

for ip in $(cat $targets)
do 
  success " Running rdp-sec-check scan against ${BOLD}${BGREEN}$ip${RESET} "
  $RDPSCAN $ip > $ip.rdp
done

success "RDP-sec-checks finished.[$end]"


