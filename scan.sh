#!/bin/bash
#by n0b1dy 2014

TARGET=$1
REPORT=$2
EXEC=`which nmap`
DIR=$3
PATHNAME=`pwd`
UDPPROTO=`which udp-proto-scanner.pl`
SSLCIPHER=`which ssl-cipher-suite-enum.pl`
SSLSCAN=`which sslscan`
HTTPPORTS=``

NIKTO=`which nikto` #saves nikto path
UNISCAN=`which uniscan` #saves uniscan
WHATWEB=`which whatweb` #whatweb path
DIRB=`which dirb` #dirb path


BOLD="\033[1m"
RESET="\033[0m"
GREEN="\033[0;92m"
RED="\033[1;31m"
ORANGE="\033[1;33m"
BLINK="\033[5m"



#web_app_scans()
#{
# cat $DIR/$REPORT.tcp.open
#}

display_usage()
{
echo -e "$RED $0 targets lab.vlan1 resultsfolder $RESET"
}

nmap_loop()
{
for ip in $(cat $TARGET)
do
echo -e "$GREEN [+]syn nmap scan $ip $RESET"
$EXEC -sS -T4 -v --reason -A $ip -oA $DIR/$REPORT.$ip.syn 2>/dev/null
echo -e "$GREEN [+]udp nmap scan $ip $RESET"
$EXEC -sU -F -v -sV --reason $ip -oA $DIR/$REPORT.$ip.udp 2>/dev/null
echo -e "$GREEN [+]udp-proto-scan $RESET"
#$UDPPROTO -f $ip > $DIR/$REPORT.$ip.udp.proto 2>/dev/null
echo -e "$GREEN [+]syn full nmap scan $ip $RESET"
$EXEC -sS -T4 -v -p- --reason -A $ip -oA $DIR/$REPORT.$ip.full.syn 2>/dev/null

done
}



network_scans()
{
    #$EXEC -sS -Pn -A -vv --reason -iL $TARGET -oA $DIR/$REPORT.tcp
    echo -e "$GREEN [+] Syn Scan "
    nmap_loop;
    for ip in $(cat $TARGET)
    do
    cat $DIR/$REPORT.$ip.full.syn >> $DIR/$REPORT.tcp.nmap
    done
	cat $DIR/$REPORT.tcp.nmap | grep "open" | cut -d/ -f1 | grep -v "Warning" | sort -n | uniq > $DIR/$REPORT.tcp.open
	echo -e "$GREEN [+]Open TCP Ports $RESET"
	cat $DIR/$REPORT.tcp.open
	cat $DIR/$REPORT.tcp.nmap | grep "filtered" | cut -d/ -f1 | grep -v "Warning" | sort -n | uniq > $DIR/$REPORT.tcp.filtered
	echo -e "$ORANGE [+]Filtered TCP Ports $RESET"
	cat $DIR/$REPORT.tcp.filtered
	cat $DIR/$REPORT.tcp.nmap | grep "closed" | cut -d/ -f1 | grep -v "Warning" | sort -n | uniq > $DIR/$REPORT.tcp.closed
	echo -e "$RED [+]Closed TCP Ports $RESET"
	cat $DIR/$REPORT.tcp.filtered
	#echo -e "$GREEN [+]Perform Thorough Syn Scan "
	nmap_loop;
	#$EXEC -sS -T4 --reason -A -p- -iL $TARGET -oA $DIR/$REPORT.full 1> /dev/null
}


display_results()
{
  
  finish_time=`date`
  END=$finish_time
  echo -e "$GREEN [+]-----------------------------------------------------------------------$RESET"
  sleep 1
  echo -e "$GREEN   [$END]:Results:[*] $BLINK"
  #less $DIR/$REPORT.full.nmap
  echo -e "$GREEN [+]Open TCP Ports $BLINK"
  cat $DIR/$REPORT.tcp.open
}

#echo $UDPPROTO
if [ -z "$TARGET" ]
then
	display_usage;
	exit
fi

start_time=`date`
echo -e "$GREEN [+]Scan Scanning Initiating$RESET"
echo 
echo -e "$RED Targets : $TARGET -Report: $REPORT.full.tcp $RESET"
echo
echo -e "$GREEN [+]-----------------------------------------------------------------------$RESET"
sleep 1

if [ -d $DIR ];then
	network_scans;
	else
	mkdir $DIR
	network_scans;
   
fi

display_results;
exit


 
