#!/bin/sh
#by n0b1dy
if [ $# -eq 0 ]; then
echo -e "\033[1m---V-L-A-N-C-H-E-C-K--------------------\033[1m"
echo -e "\033[1m[*]Usage: $0 <targetips> <resultsfolder> <vlanid>\033[1m"
exit
fi
input=$1
results=$2
vlan=$3
mkdir $results
touch results.$input.txt
start=`date`
echo "-----------------------------"
echo "[*] VLAN Access Check v0.a n0b1dy"
echo "[*]Start Scanning: $start     " 
for i in $(cat $input); do
echo "[+]Scanning $i [$input]VLAN from $vlan VLAN."
nmap -sS -sV -p80,8080,443,21,22,23,445,88,3389 $i --reason --open -n -oN $results/nmap.$i.scan.$input.$vlan 1> /dev/null
cat $results/nmap.$i.scan.$input.$vlan | grep "Nmap scan" | cut -d" " -f5 | tee $results/servers.$input.$vlan.$i 1> /dev/null 

count=`cat $results/servers.$input.$vlan.$i | wc -l`

if [ $count -gt 0 ];
then
echo "	[!]Identified $count servers of [$input] VLAN accessible from [$vlan] VLAN"
sleep 2
echo "    [+] IPs are being saved:"
echo "    	`cat $results/servers.$input.$vlan.$i >> results.$input.txt`"
echo "---------------------------------------------------------"

else
echo -e "  [-]No servers of [$input] VLAN identified accessible from [$vlan] VLAN. \nNo route to hosts or filtered by firewall. "
fi
echo "---------------------------------------------------------"
done
end=`date`
echo "[+]Finished Scanning: $end   "
echo "[*]Generating report:"
cat results.$input.txt
echo "Total `cat results.$input.txt | wc -l` accessible from $vlan VLAN" 
echo "[*]Done."
