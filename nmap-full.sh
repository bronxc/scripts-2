#!/bin/bash
#by n0b1dy
TARGET=$1
REPORT=$2
EXEC=`which nmap`
DIR=$3
PATHNAME=`pwd`
UDPPROTO="$PATHNAME/udp-proto-scanner-1.0/udp-proto-scanner.pl"
#echo $UDPPROTO
if [ -z "$TARGET" ]
then
	echo "$0 targets lab.vlan1 resultsfolder"
	exit
fi

echo "[+]Nmap Scanning Initiating"
echo 
echo "$EXEC -sS -p- -A --reason -iL $TARGET -oA $REPORT.full.tcp"
echo
echo "[+]-----------------------------------------------------------------------"
sleep 1

if [ -d $DIR ];then
	echo "[+]Perform Initial Port Scan and Ping Sweep"
        $EXEC -sS -Pn -T4 -A -vv --reason -iL $TARGET -oA $DIR/$REPORT.tcp
	$UDPPROTO -p all -f $TARGET > $DIR/$REPORT.udp.proto
	$EXEC -sU -F -Pn -T4 --reason -iL $TARGET -oA $DIR/$REPORT.udp
	echo "[+]Perform Thorough Scan"
	$EXEC -sS -T4 --reason -A -p- -iL $TARGET -oA $DIR/$REPORT.full 1> /dev/null
	else

	mkdir $DIR
	echo "[+]Perform Initial Quick Port Scan and Ping Sweep"
        $EXEC -sS -Pn -T4 -A -vv --reason -A -iL $TARGET -oA $DIR/$REPORT.tcp
	$UDPPROTO -p all -f $TARGET >$DIR/$REPORT.udp.proto
	$EXEC -sU -F -Pn -T4 --reason -iL $TARGET -oA $DIR/$REPORT.udp
        echo "[+]Perform Thorough Scan"

	$EXEC -sS -Pn -T4 --reason -A -p- -iL $TARGET -oA $DIR/$REPORT.full 1> /dev/null
fi
echo "[+]-----------------------------------------------------------------------"
sleep 1
echo "                             [*]:Results:[*]"
less $DIR/nmap.$REPORT.full*
exit
 
