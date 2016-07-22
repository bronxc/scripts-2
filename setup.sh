#!/bin/bash
# nob1dy 2014
# Script to automate setting up additional tools and pre-requisites for Debian/Kali based systems 
# tested and works with Kali and Debian - yes
# TODO: Tidy up and clean up - Comment code and add arguments
# Add usage etc.

########################
# COLORS ######
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
BRED="\e[1;31m"
BGREEN="\e[1;32m"
BOLD="\e[1m"
RESET="\e[0m"

#GLOBAL VARIABLES
KALI=$1;

#####################

display_usage(){
if [ $# -ne 1 ]; then
echo -e "${GREEN}[*]Script to set up KALI or DEBIAN installation and additional scripts"
echo -e "${GREEN}[*]Usage: $0 [KALI=1] or [KALI=0] "
exit
fi
}

###########Generic Utilities and Updates#####################
initial_su(){
start=`date`
echo -e "${GREEN}[*]Setting up $(hostname)[laptop]\n$(uname -a) at $start ${RESET}"
sleep 2
echo -e "${YELLOW}[+]Install Updates${RESET}"
sudo apt-get update && sudo apt-get upgrade -y

}

sudo_su(){
  echo -e "${BLUE}[*]Setting up sudo ${RESET}"
  apt-get install sudo -y
  visudo
  read line
  echo -e "${GREEN}[*] increase font size${RESET}"
  nano ~/.icewm/preferences 

}

prereqs()
{

echo -e "${WHITE}[+]Installing various tools and pre-reqs ${RESET}"
## compilers  ##
  apt-get install make -y
  apt-get install gcc -y
  apt-get install build-essentials -y
  apt-get install gdb -y
  apt-get install mingw32 -y
  # headers
  apt-get install linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,') -y

## software ##  
  apt-get install git -y
  apt-get install autoconf -y
  apt-get install flex -y
  apt-get install bison -y
  apt-get install byacc -y
  apt-get install ccze -y
  
  apt-get install iftop -y
  apt-get install htop -y
  apt-get install mlocate -y
  apt-get install dia -y
  
  apt-get install unetbootin -y
  
  
## terminator 
  apt-get install terminator -y
  apt-get install screen -y
  echo -e "${YELLOW}[+] ranger file explorer${RESET}"
  apt-get install ranger -y
  
## kate , hex editor
  apt-get install kate -y
  apt-get install hexedit
  apt-get install him -y
## networking ##
  apt-get install vlan -y
  apt-get install tshark -y
  apt-get install ethtool -y # frogger
## wine##  
  dpkg --add-architecture i386
  apt-get install wine -y # for wine when installed on 64bit
  apt-get install wine-bin:i386  
## update nmap ##
  nmap --script-update

  echo -e "${YELLOW}[*] Perform the following: Application Menu -> Settings -> Appearance (default font size - 10 - changed to 13)${RESET}"
  echo -e "${YELLOW}[*] Terminal Font - default 12 -> 13, set to transparent background , changed font color to white${RESET}"
  echo -e "${YELLOW}[*] Perform the following: Keyboard Shortcuts -> Add custom shortcut -> Terminal - gnome-terminal -> Shortcut : Press CTRL ALT T${RESET}"
## repos for kali ##  
  echo -e "${YELLOW}[*]add repos to /etc/apt/sources.list for linux headers and vmware"
  echo  "deb-src http://http.kali.org/kali sana main non-free contrib" >> /etc/apt/sources.list
  echo "deb-src http://security.kali.org/kali-security sana/updates main contrib non-free" >> /etc/apt/sources.list
  read line

}



clients(){
## RDP clients
echo -e "${YELLOW}[+] RDP clients${RESET}"
apt-get install remmina -y
apt-get install freerdp-* -y
apt-get install remmina-* -y
echo -e "${YELLOW}[+] finger${RESET}"
apt-get install finger -y
echo -e "${YELLOW}[+] rlogin,rsh client, putty,tftp, filezilla${RESET}"
apt-get install rsh-client -y
apt-get install putty -y
apt-get install rwho -y
apt-get install tftp -y
apt-get install filezilla filezilla-common -y
}

archive()
{
## Archive software
echo -e "${IBLUE}[+] Archive utilities - rar, 7zip"

apt-get install unace -y
apt-get install rar -y
apt-get install unrar -y
apt-get install p7zip -y
apt-get install zip -y
apt-get install unzip -y
apt-get install p7zip-full -y
apt-get install p7zip-rar -y
apt-get install file-roller -y
apt-get install unrar -y
}

kali_su()
{
## KALI additional software set up
echo -e "${GREEN}[+]Updating Metasploit${RESET}"
msfupdate

echo -e "${BLUE}[+] Open Office"
apt-get install openoffice.org -y

apt-get install gtk-recordmydesktop recordmydesktop -y

}


password_cracking(){
apt-get install john -y 
#download and have noobify for quick l337 of words
iceweasel https://sites.google.com/site/reusablesec/Home/password-cracking-tools/noobify
#korelogic rules
wget http://contest-2010.korelogic.com/rules.txt -O korelogic-rules-forjohn.txt
}

wireless(){
# wireless for debian mainly not KALI
######  http://askubuntu.com/questions/109260/how-do-i-get-an-intel-ultimate-6300-n-working
#install firmware-iwlwifi
 
	####### As root with your text editor of choice make a new file:
	####### /etc/modprobe.d/customintel6300N.conf
	####### In that file add the line:
	####### options iwlagn bt_coex_active=0
	echo -e "${YELLOW}[+] Adding The following repository to sources.list and setting up wireless${RESET}"
    echo -e "${YELLOW}[+] deb http://http.debian.net/debian/ wheezy main non-free${RESET}"
    echo "deb http://http.debian.net/debian/ wheezy main non-free" > /etc/apt/sources.list
	apt-get install wireless-tools
	apt-get install aircrack-ng
	apt-get install wireless-linux
    apt-get install firmware-iwlwif
    #sudo nano /etc/apt/sources.list you need to add 
    #deb http://http.debian.net/debian/ wheezy main non-free
}

sniffers(){
echo -e "${YELLOW}[+] tcpdump , sniffers etc.${RESET}"

#wget http://www.tcpdump.org/release/libpcap-1.6.2.tar.gz
#tar -xvf libpcap-1.6.2 # ./configure --prefix=/usr
#sudo ./configure
#$ sudo make
#$ sudo make install
apt-get install tcpdump -y
apt-get install wireshark -y
apt-get install ngrep -y
git clone https://github.com/superkojiman/snuff/blob/master/snuff.sh #mitm, sslstrip and arp
}

scanning(){
echo -e "${YELLOW}[+] nbtscan${RESET}"
apt-get install nbtscan -y
echo -e "${YELLOW}[+] arp-scan${RESET}"
apt-get install arp-scan -y
echo -e "${YELLOW}[+] ike-scan${RESET}"
apt-get install ike-scan -y
git clone https://github.com/SECFORCE/sparta
#echo -e "${YELLOW}[+] unicorn-scan"
apt-get install python-elixir
#echo -e "${YELLOW}[+] nbtscan"
mkdir ./nbtscan
cd nbtscan
wget http://www.unixwiz.net/tools/nbtscan-source-1.0.35.tgz
tar -xvf nbtscan-source-1.0.35.tgz
make
cd ..
echo -e "${YELLOW}[+] yersinia${RESET}"
apt-get install yersinia -y



}

arp_ike_scan()
{

echo -e "${YELLOW}[+] ike-scan"
git clone https://github.com/royhills/ike-scan.git
cd ike-scan
autoreconf --install
./configure --with-openssl
make
make check
make install
cd ..
echo -e "${YELLOW}[+] arp-scan"
git clone https://github.com/royhills/arp-scan.git
cd arp-scan
autoreconf --install
./configure
make check
make install
cd ..
}

portcullis_labs()
{
echo -e "${PURPLE}[+] PCSL Labs tools download${RESET}"
mkdir ./labs
cd labs
wget --no-check-certificate https://labs.portcullis.co.uk/download/onesixtyone-0.7.tar.gz
wget --no-check-certificate https://labs.portcullis.co.uk/download/udp-proto-scanner-1.1.tar.gz
wget --no-check-certificate https://labs.portcullis.co.uk/download/hoppy-1.8.1.tar.bz2
wget --no-check-certificate https://labs.portcullis.co.uk/download/nopc-0.4.5.tar.bz2
wget --no-check-certificate https://labs.portcullis.co.uk/download/enum4linux-0.8.9.tar.gz
wget --no-check-certificate https://labs.portcullis.co.uk/download/winlanfoe-0.4.tgz
wget --no-check-certificate https://labs.portcullis.co.uk/download/ames.py.tgz
wget --no-check-certificate https://labs.portcullis.co.uk/download/rdp-sec-check-0.9.tgz
wget --no-check-certificate https://labs.portcullis.co.uk/download/iker_v1.1.tar
wget --no-check-certificate https://labs.portcullis.co.uk/download/tools/ssl-cipher-suite-enum-v1.0.0.tar.gz
tar -xvf *.tar.gz
cd ..
# for rdp sec
perl -MCPAN -e "install Convert::BER"


}

windows_priv_esc()
{
git clone https://github.com/hfiref0x/CVE-2015-1701.git
git clone https://github.com/monoxgas/Trebuchet
}

linux_post()
{
git clone https://github.com/pentestmonkey/unix-privesc-check
git clone https://github.com/rebootuser/LinEnum.git
git clone https://github.com/dwin999/ptscripts/blob/master/revershelloneliners.sh

	
}

windows_binary()
{
	git clone https://github.com/Microsoft/binskim
}

ssl()
{
git clone https://github.com/drwetter/testssl.sh
git clone https://github.com/google/nogotofail


}

java(){
echo -e "${GREEN}[+] Java, 3rd party${RESET}"
#http://www.oracle.com/technetwork/java/javase/downloads/index.html
#http://www.oracle.com/technetwork/java/javase/downloads/index.html
#Untar the Archive
#tar -xzvf /root/jdk-7u17-linux-x64.tar.gz
#mv jdk1.7.0_17 /opt
#cd /opt/jdk1.7.0_17

#3.This step registers the downloaded version of Java as an alternative, and switches it to be used as the default:

#update-alternatives --install /usr/bin/java java /opt/jdk1.8.0_25/bin/java 1
#update-alternatives --install /usr/bin/javac javac /opt/jdk1.8.0_25/bin/javac 1
#update-alternatives --install /usr/lib/mozilla/plugins/libjavaplugin.so mozilla-javaplugin.so /opt/jdk1.8.0_25/jre/lib/amd64/libnpjp2.so 1
#update-alternatives --set java /opt/jdk1.8.0_25/bin/java
#update-alternatives --set javac /opt/jdk1.8.0_25/bin/javac
#update-alternatives --set mozilla-javaplugin.so /opt/jdk1.8.0_25/jre/lib/amd64/libnpjp2.so


#4. Test

#To check the version of Java you are now running

#java -version

apt-get install default-jre  default-jdk -y
#update-java-alternatives -s java-6-sun
}

discover()
{
mkdir discover
cd discover
git clone https://github.com/leebaird/discover
}

smb(){
mkdir smb_tools
cd smb_tools
echo -e "${IRED}[+] SMBEXEC and RESPONDER and CrackMapExec"
git clone https://github.com/brav0hax/smbexec.git
git clone https://github.com/SpiderLabs/Responder.git
git clone https://github.com/mubix/FakeNetBIOS
git clone https://github.com/byt3bl33d3r/CrackMapExec
cd ..
}

whitelist_bypass()
{
  git clone https://github.com/fdiskyou/PowerOPS/
  git clone https://github.com/Cn33liz/p0wnedShell
  git clone https://github.com/Cn33liz/SharpCat
  git clone https://github.com/khr0x40sh/WhiteListEvasion
}

post_exploit()
{
mkdir mubix
cd mubix
git clone https://github.com/mubix/post-exploitation.git
git clone https://github.com/quarkslab/quarkspwdump
git clone https://github.com/pwnwiki/pwnwiki.github.io.git
git clone https://github.com/mubix/ditto

cd ..

git clone https://github.com/bidord/pykek
git clone https://github.com/ChrisTruncer/EyeWitness.git #eyewitness to scan web servers try default creds and take screenshots
git clone https://github.com/GDSSecurity/Windows-Exploit-Suggester.git
git clone https://github.com/gentilkiwi/mimikatz.git
git clone https://github.com/adamkramer/dll_hijack_detect/releases
mkdir meterpreter_loaders
cd meterpreter_loaders
git clone https://github.com/rsmudge/metasploit-loader #rsmudge metasploit loader
git clone https://github.com/SherifEldeeb/inmet.git
git clone https://github.com/SherifEldeeb/TinyMet.git
cd ..
git clone https://github.com/iagox86/dnscat2.git
git clone https://github.com/Cn33liz/Inveigh
git clone https://github.com/Cn33liz/p0wnedShell
git clone https://github.com/subTee/PoshRat
git clone https://github.com/cyberisltd/NcatPortable
git clone https://github.com/denandz/KeeFarce
git clone https://github.com/pentestify/competition-modules
mkdir windows-exploits
cd windows-exploits
git clone https://github.com/foxglovesec/Potato
git clone https://github.com/Cn33liz/p0wnedShell
git clone https://github.com/Cn33liz/SmashedPotato

cd ..
## libcrak - bash
git clone https://github.com/libcrack/bashrc.d
git clone https://github.com/a0rtega/pafish

}

thpb2()
{
	mkdir thpb2
	cd thpb2
	git clone https://github.com/cheetz/PowerTools.git
	git clone https://github.com/cheetz/c2
	git clone https://github.com/cheetz/Easy-P.git
	cd ..
}

egress()
{
	mkdir egress
	git clone https://github.com/trustedsec/egressbuster
	git clone https://github.com/ChrisTruncer/Egress-Assess.git
	cd ..
	
}

shellshock()
{

git clone https://github.com/mubix/shellshocker-pocs

}

heartbleed()
{
git clone https://github.com/sensepost/heartbleed-poc.git
}




powershell()
{
mkdir powershell
cd powershell
git clone https://github.com/HarmJ0y/PowerUp
git clone https://github.com/Cn33liz/p0wnedShell
git clone https://github.com/PowerShellMafia/PowerSploit
git clone https://github.com/HarmJ0y/CheatSheets
git clone https://github.com/samratashok/nishang
git clone https://github.com/pjhartlieb/post-exploitation.git
git clone https://github.com/putterpanda/mimikittenz
git clone https://github.com/mattifestation/PowerSploit.git
git clone https://github.com/PyroTek3/PowerShell-AD-Recon.git
git clone https://github.com/silverhack/voyeur
git clone https://github.com/nullbind/Powershellery.git
git clone https://github.com/Veil-Framework/Veil.git
git clone https://github.com/trustedsec/unicorn.git
git clone https://github.com/silentsignal/wpc-ps.git
git clone https://github.com/jaredhaight/PSAttackBuildTool
git clone https://github.com/b00stfr3ak/fast_meterpreter
git clone https://github.com/obscuresec/random/blob/master/EncodeShell.py
git clone https://github.com/nullbind/Powershellery/blob/master/Stable-ish/Get-SPN/Get-SPN.psm1
git clone https://github.com/cheetz/Easy-P.git
git clone https://github.com/darkoperator/Posh-SecMod.git
git clone https://github.com/besimorhino/powercat.git
git clone https://github.com/mattifestation/PowerShellArsenal.git
git clone https://github.com/subTee/PoshRat.git
git clone https://github.com/giMini/RWMC
git clone https://github.com/PowerShellEmpire/Empire.git
git clone https://github.com/NetSPI/PowerUpSQL
git clone https://github.com/leechristensen/UnmanagedPowerShell
cd ..
mkdir cobalt
git clone https://github.com/rvrsh3ll/POSH-Commander
cd ..

mkdir macros
cd macros
git clone https://github.com/enigma0x3/Powershell-Payload-Excel-Delivery.git
git clone https://github.com/enigma0x3/psh_web_delivery-Macro_Delivery.git
git clone https://github.com/webstersprodigy/webstersprodigy.git
git clone https://github.com/enigma0x3/Generate-Macro.git
git clone https://github.com/enigma0x3/Powershell-Infection.git
git clone https://github.com/enigma0x3/PowershellProfile.git
git clone https://github.com/enigma0x3/Powershell-Infection.git
git clone https://github.com/enigma0x3/Powershell-C2.git
git clone https://github.com/khr0x40sh/MacroShop
cd ..
cd ..
}



recon()
{
git clone https://github.com/Easy-Forex/Verify-emails
git clone https://github.com/samwize/pyExtractor.git
git clone https://github.com/nccgroup/WebFEET.git
git clone https://github.com/Hypsurus/ftpmap
git clone https://github.com/michenriksen/gitrob
git clone https://github.com/Pickfordmatt/Prowl.git
git clone https://github.com/philhagen/ip2geo
	
}

webapp()
{
mkdir webapp
cd webapp
git clone https://github.com/maurosoria/dirs3arch.git	
git clone https://github.com/m101/lfipwn/blob/master/lfipwn.py
cd ..	
}

phishing()
{
	git clone https://github.com/cheetz/spearphishing
	git clone https://github.com/Section9Labs/Cartero
	git clone https://gist.github.com/monoxgas/7fec9ec0f3ab405773fc
}

lateral()
{
	mkdir lateral
	cd lateral
	git clone https://github.com/poweradminllc/PAExec
	git clone https://github.com/secabstraction/Create-WMIshell
	git clone https://github.com/cyberisltd/OpenVPN-RAT-Bridge
	mkdir kerberos
	git clone https://github.com/nidem/kerberoast
	git clone https://github.com/gentilkiwi/kekeo
	git clone https://github.com/rvazarkar/KrbCredExport
	cd ..
	cd ..
}

network_tools
{
#http://www.commonexploits.com/penetration-testing-scripts/
echo -e "${GREEN}[+] Downloading Common Exploits${RESET}"

mkdir ./network_tools
cd network_tools
git clone https://github.com/commonexploits/dtpscan.git
git clone https://github.com/commonexploits/livehosts
git clone https://github.com/commonexploits/port-scan-automation
git clone https://github.com/commonexploits/whatsfree
git clone https://github.com/commonexploits/weape
git clone https://github.com/commonexploits/winocphc
git clone https://github.com/commonexploits/ipgen
git clone https://github.com/commonexploits/vlan-hopping
git clone https://github.com/commonexploits/icmpsh
git clone https://github.com/nccgroup/cisco-SNMP-enumeration
git clone https://github.com/nccgroup/vlan-hopping---frogger

cd ..
}


servers(){
echo -e "${YELLOW}[+] Tftp server${RESET}"
apt-get install atftpd -y
echo "atftpd --daemon --port 69 --bind-address yourip /tmp"
echo "netstat -anu | grep 69"
#echo -e "${YELLOW}[+] RDP server"
#apt-get install xrdp -y
}

news()
{
	mkdir news
	cd news
	git clone https://github.com/fdiskyou/feedme
	cd ..
	
}


clamav()
{
  apt-get install clamav
  apt-get install clamav-freshclam
  sudo apt-get install clamtk
  
}


virtualbox()
{
apt-get install virtualbox virtualbox-guest-x11 virtualbox-guest-utils virtualbox-guest-additions -y
apt-get install virtualbox-ose-dkms -y
}


virtual_machine_kvm()
{

apt-get install virt-manager -y
apt-get install libvirt-bin -y
apt-get install ssh-askpass -y
apt-get install virt-goodies -y
}


nvidia()
{
echo test
#############NVIDIA CHIPSET#######################################
echo -e "${PURPLE}[+]Adding NVIDIA repository"
add-apt-repository ppa:ubuntu-x-swat/x-updates
echo -e "${PURPLE}[+]Setting up Nvidia Drivers "
apt-get update && apt-get install nvidia-current nvidia-current-modaliases nvidia-settings
echo -e "${GREEN}[i]Reboot and ${BLUE}nvidia-xconfig"
}

howto()
{
mkdir howto
git clone https://github.com/StarshipEngineer/OpenVPN-Setup
git clone https://github.com/stackp/Droopy
cd ..
}

defence(){
	mkdir defence
	cd defence
	git clone https://github.com/micheloosterhof/cowrie
	cd ..
	
}


#display_usage;
initial_su;
sudo_su;
pre-reqs;
clients;
archive;
kali_su;
password_cracking;
sniffers;
scanning;
discover;
portcullis_labs;
arp_ike_scan;

windows_priv_esc;
powershell;
lateral;
linux_post;
#java;
ssl;
heartbleed;
shellshock;
recon;
webapp;
phishing;
news;
network_tools;
howto;s
servers;
thpb2;
smb;
whitelist_bypass;
windows_binaries;
#clamav;
#virtual_machine_kvm;
#virtualbox;
#wireless;
#nvidia;

