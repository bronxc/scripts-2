#!/bin/bash
# by n0b1dy
# get as an input .nmap scan and gives the uniq open ports that are open

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
usage "Script to display open ports found with nmap scan (nmap format) and for nessus policy."
usage "$0 [filename].nmap outfile"
exit
fi




if [ $# -eq 2 ]; then

filename=$1
output=$2

cat $filename | grep "open" | cut -d/ -f1 | grep -v "Warning" | sort -n | uniq > $output.open
msgline
info "Open Ports Identified"
cat $output.open
msgline

  info "Nessus Policy friendly"
  echo "">$output.open.nessus
  for port in $(cat $output.open)
  do 
  echo -n "$port, ">> $output.open.nessus
  done
cat $output.open.nessus
exit
fi