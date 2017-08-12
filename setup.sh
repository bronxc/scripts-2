#!/bin/bash
#--------------------------------------#
# Author: nob1dy 2014-2016     (Update: 2016-08)
# Description: 
#-installation script for Debian/Kali - Configuration
# Operating System: Kali - tested
# Requirements: Root and Internet Connection
#--------------------------------------#

# Default and Global Vars
# COLORS 
RED="\e[0;31m" # Errors
GREEN="\e[0;32m" # Success
YELLOW="\e[0;33m" # Warning 
BLUE="\e[0;34m" # Background
PURPLE="\e[0;35m" # Emphasise
HPURPLE="\e[1;35m"
IRED="\e[0;91m"
IGREEN="\e[0;92m"
IYELLOW="\e[0;93m" # Progress
IBLUE="\e[0;94m"
BRED="\e[1;31m"
BGREEN="\e[1;32m"
BOLD="\e[1m" # Bold
RESET="\e[0m" # Normal

#GLOBAL VARIABLES
KALI=true;
#####################

START=`date`
CURRENT=`pwd`


######################

msg() { echo -e "${BOLD}[*]$(date '+%d/%m/%y %H:%M:%S') ${@} ${RESET}"; }
info() { echo -e "${BOLD}${IGREEN}[*]$(date '+%d/%m/%y %H:%M:%S') ${@} ${RESET}"; }
success() { echo -e "${BOLD}${BGREEN}[*]$(date '+%d/%m/%y %H:%M:%S') [SUCCESS] ${@} ${RESET}"; }
error()   { echo -e "${BOLD}${BRED}[*]$(date '+%d/%m/%y %H:%M:%S') [ERROR] ${@} ${RESET}"; }
download() { wget --no-cookies --no-check-certificate "${@}";}
clone() { git clone "${@}";}
install() { apt-get -qq install "${@}" -y;}


usage(){
if [ $# -ne 1 ]; then
error "Post-installation script for Debian/Kali - Configuration"
exit
fi
}

# Update - Initialise
init(){
info "$(hostname)\n$(whoami)\n$(uname -a)"
msg "Adding repos to /etc/apt/sources.list for linux kernel headers and VMware"
echo "deb-src http://http.kali.org/kali sana main non-free contrib" >> /etc/apt/sources.list
echo "deb-src http://security.kali.org/kali-security sana/updates main contrib non-free" >> /etc/apt/sources.list
msg "Updating"
sudo apt-get -qq update && sudo apt-get -qq upgrade -y
success "Updating completed"
info "Linux kernel headers"
install linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,')
msg "Updating Metasploit"
msfupdate
}

sudo_setup(){
  msg "Sudo Set up"
  install sudo
  visudo
  read line
}

prereqs()
{

msg "Installing pre-reqs for next steps ( tools, compilers etc.)"
info "compilers"
install ccze
install make
install gcc
install build-essentials
install gdb
install mingw32
info "Software"
install git
install autoconf
install flex
install bison
install byacc
install iftop
install htop
install mlocate
install dia
install unetbootin
install ranger
info "Conky - Aesthetics"
install conky-all
install conky-manager
info "Terminal utilities ( Terminator)"
install terminator
install screen
install bash-completion
install zsh
clone https://github.com/libcrack/bashrc.d
info "Text Editors ( Kate, Hex)" 
install kate
install hexedit
install him
info "Networking tools"
install vlan
install tshark
install ethtool
info "Sniffers"
install tcpdump
install wireshark
install ngrep
info "Wine"  
dpkg --add-architecture i386
install wine # for wine when installed on 64bit
install wine-bin:i386  
info "Nmap script update"
nmap --script-update

}

manual()
{
  info "Perform the following: Application Menu -> Settings -> Appearance (default font size - 10 - changed to 13)"
  info "Terminal Font - default 12 -> 13, set to transparent background , changed font color to white"
  info "Perform the following: Keyboard Shortcuts -> Add custom shortcut -> Terminal - gnome-terminal -> Shortcut : Press CTRL ALT T"
}


clients(){
## RDP clients
msg "RDP clients"
install remmina
install freerdp-*
install remmina-*
msg "Finger, rsh, rlogin, putty"
install finger
install rsh-client
install putty
install rwho
install tftp
msg "Ftp"
install filezilla
install filezilla-common
}

archive()
{
## Archive software
msg "Archive utilities (rar, 7zip)"
install unace
install rar
install unrar
install p7zip
install zip
install unzip
install p7zip-full
install p7zip-rar
install file-roller
install unrar
}

extras()
{
## KALI additional software set up
msg "Open Office"
install openoffice.org
install gtk-recordmydesktop 
install recordmydesktop

}


password_cracking(){
install john 
#download and have noobify for quick l337 of words
mkdir dictionaries
cd dictionaries
download https://sites.google.com/site/reusablesec/Home/password-cracking-tools/noobify/noobify.tgz?attredirects=0&d=1
#korelogic rules
download http://contest-2010.korelogic.com/rules.txt -O korelogic-rules-forjohn.txt
#crackstation
download https://crackstation.net/files/crackstation-human-only.txt.gz 
download http://scrapmaker.com/download/data/wordlists/dictionaries/rockyou.txt.bz2
cd ..
}

wireless(){
# wireless for debian mainly not KALI
######  http://askubuntu.com/questions/109260/how-do-i-get-an-intel-ultimate-6300-n-working
#install firmware-iwlwifi
 
	####### As root with your text editor of choice make a new file:
	####### /etc/modprobe.d/customintel6300N.conf
	####### In that file add the line:
	####### options iwlagn bt_coex_active=0
	info "Adding The following repository to sources.list and setting up wireless"
    info "deb http://http.debian.net/debian/ wheezy main non-free"
    echo "deb http://http.debian.net/debian/ wheezy main non-free" > /etc/apt/sources.list
	install wireless-tools
	install aircrack-ng
	install wireless-linux
    install firmware-iwlwif
    #sudo nano /etc/apt/sources.list you need to add 
    #deb http://http.debian.net/debian/ wheezy main non-free
}

sniffers(){
info "tcpdump , sniffers etc."

#wget http://www.tcpdump.org/release/libpcap-1.6.2.tar.gz
#tar -xvf libpcap-1.6.2 # ./configure --prefix=/usr
#sudo ./configure
#$ sudo make
#$ sudo make install
clone https://github.com/superkojiman/snuff/blob/master/snuff.sh #mitm, sslstrip and arp
info "yersinia"
install yersinia
}

scanning(){
msg "Installing scanning tools (nbstscan, arp-scan)"
info "nbtscan"
install nbtscan
info "arp-scan"
install arp-scan
info "ike-scan"
install ike-scan
info "ike-scan - git"
clone https://github.com/royhills/ike-scan.git
cd ike-scan
autoreconf --install
./configure --with-openssl
make
make check
make install
cd ..
info "arp-scan - git"
clone https://github.com/royhills/arp-scan.git
cd arp-scan
autoreconf --install
./configure
make check
make install
cd ..
clone https://github.com/SECFORCE/sparta
#info "unicorn-scan"
install python-elixir
info "nbtscan (unixwiz)"
mkdir ./nbtscan
cd nbtscan
download http://www.unixwiz.net/tools/nbtscan-source-1.0.35.tgz
tar -xvf nbtscan-source-1.0.35.tgz
make
cd ..
clone https://github.com/ChrisTruncer/EyeWitness.git #eyewitness to scan web servers try default creds and take screenshots
clone https://github.com/scipag/vulscan
clone https://github.com/maaaaz/nmaptocsv
}

pcsl()
{
msg " Portcullis Labs tools download"
mkdir ./pcsl
cd pcsl
download https://labs.portcullis.co.uk/download/onesixtyone-0.7.tar.gz
download https://labs.portcullis.co.uk/download/udp-proto-scanner-1.1.tar.gz
download https://labs.portcullis.co.uk/download/hoppy-1.8.1.tar.bz2
download https://labs.portcullis.co.uk/download/nopc-0.4.7.tar.bz2
download https://labs.portcullis.co.uk/download/enum4linux-0.8.9.tar.gz
download https://labs.portcullis.co.uk/download/winlanfoe-0.4.tgz
download https://labs.portcullis.co.uk/download/ames.py.tgz
download https://labs.portcullis.co.uk/download/rdp-sec-check-0.9.tgz
download https://labs.portcullis.co.uk/download/iker_v1.1.tar
download https://labs.portcullis.co.uk/download/FreeRDP-pth.tar.gz
download https://labs.portcullis.co.uk/download/tools/ssl-cipher-suite-enum-v1.0.0.tar.gz
tar -xvf *.tar.gz
cd ..
# for rdp sec
perl -MCPAN -e "install Convert::BER"


}

windows_priv_esc()
{
clone https://github.com/hfiref0x/CVE-2015-1701.git
clone https://github.com/monoxgas/Trebuchet
clone https://github.com/foxglovesec/RottenPotato
}

linux_post()
{
clone https://github.com/pentestmonkey/unix-privesc-check
clone https://github.com/rebootuser/LinEnum.git
clone https://github.com/dwin999/ptscripts/blob/master/revershelloneliners.sh

	
}

windows_binary()
{
	clone https://github.com/Microsoft/binskim
}

ssl()
{
clone https://github.com/drwetter/testssl.sh
}

java-setup(){
msg "Java, 3rd party"
http://www.oracle.com/technetwork/java/javase/downloads/index.html
#http://www.oracle.com/technetwork/java/javase/downloads/index.html
info "Downloading java from oracle.com"
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u45-b14/jdk-8u45-linux-x64.tar.gz"
#Untar the Archive
tar -xzvf jdk-8u45-linux-x64.tar.gz
mv jdk1.8.0_45 /opt/
cd /opt/jdk1.8.0_45

#3.This step registers the downloaded version of Java as an alternative, and switches it to be used as the default:

update-alternatives --install /usr/bin/java java /opt/jdk1.8.0_45/bin/java 1
update-alternatives --install /usr/bin/javac javac /opt/jdk1.8.0_45/bin/javac 1
update-alternatives --install /usr/lib/mozilla/plugins/libjavaplugin.so mozilla-javaplugin.so /opt/jdk1.8.0_45/jre/lib/amd64/libnpjp2.so 1
update-alternatives --set java /opt/jdk1.8.0_45/bin/java
update-alternatives --set javac /opt/jdk1.8.0_45/bin/javac
update-alternatives --set mozilla-javaplugin.so /opt/jdk1.8.0_45/jre/lib/amd64/libnpjp2.so
msg "Java, from repo"
install default-jre
install default-jdk
java -version
cd $CURRENT
}

discover()
{
mkdir discover
cd discover
clone https://github.com/leebaird/discover /opt/discover/
cd /opt/discover
cd $CURRENT
}

smb(){
mkdir smb-tools
cd smb-tools
info "Smb tools, responder, smbexec etc.."
clone https://github.com/brav0hax/smbexec.git
clone https://github.com/lgandx/Responder
clone https://github.com/lgandx/PCredz
clone https://github.com/mubix/FakeNetBIOS
clone https://github.com/byt3bl33d3r/CrackMapExec
clone https://github.com/Raikia/CredNinja
clone https://github.com/ChrisTruncer/WMIOps
clone https://github.com/adaptivethreat/BloodHound
clone https://github.com/ctxis/wsuspect-proxy
clone https://github.com/3gstudent/Smbtouch-Scanner
cd ..
}

whitelist_bypass()
{
  mkdir whitelist 
  cd whitelist
  clone https://github.com/fdiskyou/PowerOPS/
  clone https://github.com/fdiskyou/PSShell
  clone https://github.com/Cn33liz/p0wnedShell
  clone https://github.com/Cn33liz/SharpCat
  clone https://github.com/khr0x40sh/WhiteListEvasion
  clone https://github.com/subTee/AllTheThings
  cloen https://github.com/Ben0xA/AwesomerShell
  clone https://gist.github.com/subTee/0b93971e02bbf564220f 
  clone https://gist.github.com/subTee/7e3f8979eafbe65d63e2
  clone https://gist.github.com/subTee/18c66a5827b16426d244afa8ae3ba20a
  clone https://github.com/subTee/Shellcode-Via-HTA
  cd ..
}

post_exploit()
{
mkdir post-exploit
cd post-exploit
clone https://github.com/mubix/post-exploitation.git
clone https://github.com/quarkslab/quarkspwdump
clone https://github.com/pwnwiki/pwnwiki.github.io.git
clone https://github.com/mubix/ditto
clone https://github.com/Shellntel/scripts/
clone https://github.com/bidord/pykek
clone https://github.com/gentilkiwi/mimikatz.git
clone https://github.com/mwrlabs/XRulez
clone https://github.com/killswitch-GUI/Persistence-Survivability
clone https://github.com/Shellntel/OWA-Toolkit
clone https://github.com/dafthack/MailSniper
clone https://github.com/sensepost/ruler
clone https://github.com/tfairane/HackStory
clone https://github.com/funoverip/mcafee-sitelist-pwd-decryption
clone https://github.com/seastorm/PuttyRider
clone https://github.com/schierlm/JavaPayload
clone https://github.com/colemination/PowerOutlook
clone https://github.com/turbo/zero2hero
clone https://github.com/FuzzySecurity/PowerShell-Suite/tree/master/Bypass-UAC
clone https://github.com/FuzzySecurity/PowerShell-Suite
clone https://github.com/hfiref0x/UACME
clone https://github.com/frego/fwshell
clone https://github.com/Mr-Un1k0d3r/DKMC
clone https://github.com/p3nt4/PSUnlock
clone https://github.com/Mr-Un1k0d3r/RC4-PowerShell-RAT
clone https://github.com/stufus/parse-mimikatz-log/blob/master/pml.py
clone https://github.com/PowerShell/PowerShell
clone https://github.com/3gstudent/Smallp0wnedShell
clone https://github.com/chango77747/AdEnumerator

mkdir dll_hijack_detect
cd dll_hijack_detect
clone https://github.com/adamkramer/dll_hijack_detect
download https://github.com/adamkramer/dll_hijack_detect/releases/download/v1.0/dll_hijack_detect_x64.exe
download https://github.com/adamkramer/dll_hijack_detect/releases/download/v1.0/dll_hijack_detect_x86.exe
download https://github.com/adamkramer/dll_hijack_detect/releases/download/v1.0/dll_hijack_test.exe
download https://github.com/adamkramer/dll_hijack_detect/releases/download/v1.0/dll_hijack_test_dll.dll
cd ..
mkdir meterpreter-loaders
cd meterpreter-loaders
clone https://github.com/rsmudge/metasploit-loader #rsmudge metasploit loader
clone https://github.com/SherifEldeeb/inmet.git
clone https://github.com/SherifEldeeb/TinyMet.git
cd ..
clone https://github.com/iagox86/dnscat2.git
clone https://github.com/lukebaggett/dnscat2-powershell
clone https://github.com/sensepost/DNS-Shell
clone https://github.com/Cn33liz/Inveigh
clone https://github.com/Cn33liz/p0wnedShell
clone https://github.com/Cn33liz/EasySystem
clone https://github.com/subTee/PoshRat
clone https://github.com/manwhoami/Bella
clone https://github.com/cyberisltd/NcatPortable
clone https://github.com/denandz/KeeFarce
clone https://github.com/pentestify/competition-modules
mkdir windows-exploits
cd windows-exploits
clone https://github.com/foxglovesec/Potato
clone https://github.com/Cn33liz/SmashedPotato
clone https://github.com/GDSSecurity/Windows-Exploit-Suggester.git
clone https://github.com/rasta-mouse/Sherlock
clone https://github.com/RiskSense-Ops/MS17-010
cd ..
cd $CURRENT



}

thpb2()
{
	mkdir thpb2
	cd thpb2
	clone https://github.com/cheetz/PowerTools.git
	clone https://github.com/cheetz/c2
	clone https://github.com/cheetz/Easy-P.git
	cd ..
}

egress()
{
	mkdir egress
	cd egress
	clone https://github.com/trustedsec/egressbuster
	clone https://github.com/ChrisTruncer/Egress-Assess.git
	clone https://github.com/Shellntel/websocket_egress
	clone https://github.com/PaulSec/twittor
	clone https://github.com/sensepost/DNS-Shell
	clone https://github.com/stufus/egresscheck-framework
	clone https://github.com/zerosum0x0/koadic
	cd ..
	cd $CURRENT
}

shellshock()
{
cd $CURRENT
clone https://github.com/mubix/shellshocker-pocs

}

heartbleed()
{
cd $CURRENT
clone https://github.com/sensepost/heartbleed-poc.git
}

mainframe()
{
cd $CURRENT
mkdir mainframe
cd mainframe
clone https://github.com/ayoul3/cicspwn
clone https://github.com/ayoul3/Privesc
clone https://github.com/ayoul3/cicsshot
cd ..
}
powershell()
{
cd $CURRENT
mkdir powershell
cd powershell
clone https://github.com/HarmJ0y/PowerUp
clone https://github.com/Cn33liz/p0wnedShell
clone https://github.com/PowerShellMafia/PowerSploit
clone https://github.com/HarmJ0y/CheatSheets
clone https://github.com/samratashok/nishang
clone https://github.com/pjhartlieb/post-exploitation.git
clone https://github.com/putterpanda/mimikittenz
clone https://github.com/PyroTek3/PowerShell-AD-Recon.git
clone https://github.com/silverhack/voyeur
clone https://github.com/nullbind/Powershellery.git
clone https://github.com/Veil-Framework/Veil.git
clone https://github.com/trustedsec/unicorn.git
clone https://github.com/silentsignal/wpc-ps.git
clone https://github.com/jaredhaight/PSAttackBuildTool
clone https://github.com/b00stfr3ak/fast_meterpreter
clone https://github.com/obscuresec/random/blob/master/EncodeShell.py
clone https://github.com/nullbind/Powershellery/blob/master/Stable-ish/Get-SPN/Get-SPN.psm1
clone https://github.com/cheetz/Easy-P.git
clone https://github.com/darkoperator/Posh-SecMod.git
clone https://github.com/besimorhino/powercat.git
clone https://github.com/mattifestation/PowerShellArsenal.git
clone https://github.com/subTee/PoshRat.git
clone https://github.com/giMini/RWMC
clone https://github.com/PowerShellEmpire/Empire.git
clone https://github.com/NetSPI/PowerUpSQL
clone https://github.com/leechristensen/UnmanagedPowerShell
clone https://github.com/danielbohannon/Invoke-Obfuscation
clone https://github.com/vysec/Invoke-CradleCrafter
clone https://github.com/vysec/Invoke-Phant0m
clone https://github.com/countercept/doublepulsar-usermode-injector
clone https://github.com/fullmetalcache/PowerLine
clone https://github.com/fullmetalcache/PowerStripper
clone https://github.com/whitehat-zero/PowEnum
cd ..
mkdir cobalt
clone https://github.com/rvrsh3ll/POSH-Commander
clone https://github.com/kussic/CS-KickassBot/blob/master/kickassbot.cna
clone https://github.com/rsmudge/Malleable-C2-Profiles/tree/master/normal
clone https://github.com/killswitch-GUI/CobaltStrike-ToolKit
clone https://github.com/mdsecresearch/Publications/blob/master/tools/redteam/cna/eventvwr.cna
clone https://github.com/outflankbv/NetshHelperBeacon
clone https://github.com/bluscreenofjeff/Red-Team-Infrastructure-Wiki
clone https://github.com/bluscreenofjeff/AggressorScripts
clone https://github.com/rsmudge/ElevateKit
clone https://github.com/mdsecactivebreach/CACTUSTORCH
clone https://github.com/Mr-Un1k0d3r/RedTeamPowershellScripts
clone https://github.com/bluscreenofjeff/AggressorScripts
clone https://github.com/ZonkSec/persistence-aggressor-script
clone https://github.com/Und3rf10w/Aggressor-scripts

cd ..
mkdir macros
cd macros
clone https://github.com/enigma0x3/Powershell-Payload-Excel-Delivery.git
clone https://github.com/enigma0x3/psh_web_delivery-Macro_Delivery.git
clone https://github.com/webstersprodigy/webstersprodigy.git
clone https://github.com/enigma0x3/Generate-Macro.git
clone https://github.com/enigma0x3/PowershellProfile.git
clone https://github.com/enigma0x3/Powershell-C2.git
clone https://github.com/khr0x40sh/MacroShop
cd ..
cd $CURRENT
}



recon()
{
info "Recon and Info gathering tools"
mkdir recon
cd recon
clone https://github.com/Easy-Forex/Verify-emails
clone https://github.com/samwize/pyExtractor.git
clone https://github.com/killswitch-GUI/SimplyEmail
clone https://github.com/nccgroup/WebFEET.git
clone https://github.com/Hypsurus/ftpmap
clone https://github.com/michenriksen/gitrob
clone https://github.com/Pickfordmatt/Prowl.git
clone https://github.com/philhagen/ip2geo
clone https://github.com/upgoingstar/datasploit
clone https://github.com/jivoi/awesome-osint
clone https://github.com/hslatman/awesome-threat-intelligence
cd ..
cd $CURRENT
}

webapp()
{
info "Web app tools, lfi, dirsearch and mobile"
mkdir webapp
cd webapp
clone https://github.com/maurosoria/dirs3arch.git	
clone https://github.com/m101/lfipwn/blob/master/lfipwn.py
cd ..	
mkdir mobile
cd mobile
clone https://github.com/mwrlabs/needle
cd ..
cd $CURRENT
}

phishing()
{
	mkdir phish
	cd phish
	clone https://github.com/cheetz/spearphishing
	clone https://cybersyndicates.com/project/SimplyTemplate/
	clone https://github.com/Section9Labs/Cartero
	clone https://gist.github.com/monoxgas/7fec9ec0f3ab405773fc
	clone https://github.com/Mr-Un1k0d3r/CatMyFish
	clone https://github.com/bmericc/domainhunter
	clone https://github.com/niravkdesai/haveibeenpwned
	clone https://github.com/vysec/FindFrontableDomains
	clone https://github.com/vysec/morphHTA
	clone https://github.com/n0pe-sled/Postfix-Server-Setup
	clone https://gist.github.com/tomsteele/6275546
	clone https://github.com/nccgroup/demiguise
	cd ..
	cd $CURRENT
}

lateral()
{
	mkdir lateral
	cd lateral
	clone https://github.com/poweradminllc/PAExec
	clone https://github.com/secabstraction/Create-WMIshell
	clone https://github.com/cyberisltd/OpenVPN-RAT-Bridge
	mkdir kerberos
	clone https://github.com/nidem/kerberoast
	clone https://github.com/xan7r/kerberoast
	clone https://github.com/gentilkiwi/kekeo
	clone https://github.com/rvazarkar/KrbCredExport
	clone https://github.com/Twi1ight/AD-Pentest-Script
	cd ..
	cd ..
	cd $CURRENT
}

network-tools()
{
#http://www.commonexploits.com/penetration-testing-scripts/
info "Downloading Common Exploits Repository - Vlan hopping, cisco snmp enum etc."

mkdir ./common-exploits
cd common-exploits
clone https://github.com/commonexploits/dtpscan.git
clone https://github.com/commonexploits/livehosts
clone https://github.com/commonexploits/port-scan-automation
clone https://github.com/commonexploits/whatsfree
clone https://github.com/commonexploits/weape
clone https://github.com/commonexploits/winocphc
clone https://github.com/commonexploits/ipgen
clone https://github.com/commonexploits/vlan-hopping
clone https://github.com/commonexploits/icmpsh
clone https://github.com/nccgroup/cisco-SNMP-enumeration
clone https://github.com/commonexploits/cisco-SNMP-enumeration/
clone https://github.com/nccgroup/vlan-hopping---frogger

cd ..
cd $CURRENT
}


servers(){
info "Tftp server"
install atftpd
echo "atftpd --daemon --port 69 --bind-address yourip /tmp"
echo "netstat -anu | grep 69"
#info "RDP server"
#install xrdp
}

news()
{
	mkdir news
	cd news
	clone https://github.com/fdiskyou/feedme
	cd ..
	
}


clamav()
{
  install clamav
  install clamav-freshclam
  install clamtk
  
}


virtualbox()
{
install virtualbox virtualbox-guest-x11 virtualbox-guest-utils virtualbox-guest-additions
install virtualbox-ose-dkms
}


virtual_machine_kvm()
{

install virt-manager
install libvirt-bin
install ssh-askpass
install virt-goodies
}


nvidia()
{
echo test
#############NVIDIA CHIPSET#######################################
msg "Adding NVIDIA repository"
add-apt-repository ppa:ubuntu-x-swat/x-updates
msg "Setting up Nvidia Drivers "
apt-get update && install nvidia-current nvidia-current-modaliases nvidia-settings
echo -e "${GREEN}[i]Reboot and ${BLUE}nvidia-xconfig"
}

howto()
{
mkdir howto
clone https://github.com/StarshipEngineer/OpenVPN-Setup
clone https://github.com/stackp/Droopy
cd ..
}

defence(){
	msg "Defensive and Hunting scripts and tools"
	mkdir defence
	cd defence
	clone https://github.com/micheloosterhof/cowrie
	clone https://github.com/a0rtega/pafish
	clone https://github.com/apthunting/APT-Hunter
	clone https://github.com/davehull/Get-StakRank
	clone https://github.com/theonehiding/ShimCacheParser
	clone https://github.com/theonehiding/ShimCacheCollector
	clone https://github.com/paralax/awesome-honeypots
	clone https://github.com/LordNoteworthy/al-khaser
	clone https://github.com/Neo23x0/Loki
	clone https://github.com/Neo23x0/Fenrir
	clone https://github.com/Neo23x0/signature-base#
	clone https://github.com/davehull/Kansa
	clone https://github.com/swannman/ircapabilities
	clone https://github.com/secureworks/dcept
	clone https://github.com/PaulSec/awesome-windows-domain-hardening
	clone https://gist.github.com/Neo23x0/a4b4af9481e01e749409
	clone https://github.com/papadp/reflective-injection-detection
	clone https://github.com/singlethreaded/irFARTpull
	clone https://github.com/FuzzySecurity/PowerShell-Suite
	clone https://github.com/rjhansen/nsrllookup
	clone https://github.com/nccgroup/Cyber-Defence
	clone https://github.com/meirwah/awesome-incident-response 
	clone https://github.com/PrometheanInfoSec/cryptolocked-ng#
	clone https://github.com/CylanceVulnResearch/ReflectiveDLLRefresher
	clone https://github.com/ThreatHuntingProject/ThreatHunting
	clone https://github.com/williballenthin/process-forest
	clone https://github.com/jephthai/OpenPasswordFilter
	clone https://github.com/shjalayeri/MCEDP
	cd ..
	
}

ios_tools(){

msg "iOS Application testing tools"
clone https://github.com/tanprathan/MobileApp-Pentest-Cheatsheet
msg "MWR Needle"
clone https://github.com/mwrlabs/needle.git
msg "Needle and mobile testing pre-reqs"
# Unix packages
apt-get install python2.7 python2.7-dev sshpass sqlite3 libimobiledevice4 libimobiledevice-utils lib32ncurses5-dev
# Python packages
pip install readline
pip install paramiko
pip install sshtunnel
pip install frida
pip install mitmproxy

}

fingerprinting(){
 msg "Fingerprinting - AV detection"
 mkdir fingerprint
 cd fingerprint
 clone https://github.com/vah13/AVDetection
 cd ..
}

winapi(){
mkdir winapi
cd winapi
clone https://github.com/floodyberry/genwrapper
clone https://github.com/LordNoteworthy/al-khaser
clone https://github.com/a0rtega/pafish
clone https://github.com/BreakingMalwareResearch
clone https://github.com/MalwareTech/CreateDesktop
clone https://github.com/frego/Shellcode
clone https://gist.github.com/securitytube/c956348435cc90b8e1f7
clone https://github.com/secrary/InjectProc
clone https://github.com/countercept/doublepulsar-usermode-injector
clone https://github.com/0xd4d/de4dot
clone https://github.com/zerosum0x0/ThreadContinue
clone https://github.com/0xd4d/dnSpy
clone https://github.com/nyx0/DLL-Inj3cti0n
clone https://github.com/OpenSecurityResearch/dllinjector
clone https://github.com/fdiskyou/injectAllTheThings/tree/master/injectAllTheThings
clone https://github.com/fancycode/MemoryModule
clone https://github.com/brandonprry/wicked_cool_shell_scripts_2e
clone https://github.com/monoxgas/sRDI
clone https://github.com/zerosum0x0/defcon-25-workshop
cd ..

}

exploits()
{
mkdir exploits
cd exploits
clone https://github.com/foxglovesec/JavaUnserializeExploits
cd ..
cd $CURRENT
}

#usage;
init;
prereqs;
clients;
archive;
extras;
password_cracking;
#wireless
sniffers;
scanning;
pcsl;
windows_priv_esc;
discover;
ssl;
java-setup;
smb;
whitelist_bypass;
exploits;
post_exploit;
thpb2;
egress;
shellshock;
heartbleed;
powershell;
network-tools;
recon;
webapp;
lateral;
news;
clamav;
defence;
fingerprinting;
howto;
winapi;
sudo_setup;
manual;








