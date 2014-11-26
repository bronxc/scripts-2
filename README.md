README.md
=======
Collection of scripts which maybe helpful for engagements.
Made and should work in Kali.

Work in progress, some bad coding out there. :D

**Setup.sh**

Script to set up additional tools and dependencies on kali/debian based systems.
Useful for a quick out of the box deployment for Kali Linux on a physical machine or VM.

**Metasploit Payloads**
* bind_metgen.sh
Script to generate automatically bind meterpreter payloads from metasploit and
launch multihandler against target. Will move payload to /var/www and start apache for delivery

* reverse_metgen.sh
Same as above for reverse shell. Works better.

**Scanning**
Self explanatory, scripts to invoke nikto, ssl and run scans against targets and ports, saving results separately
in a format ip.port.tool

* ssl-cipher.sh
* nikto-scan.sh

**Nmap Scanning**

* nmap-full.sh #Automates nmap scans WIP
* open.sh # reads from a nmap file and displays open ports and ports in a format to be fed in Nessus
* vlancheck.sh # quick nmap wrapper to check ports and hosts accessible from one VLAN to another VLAN 

**Metasploit**

Scripts to invoke psexec and known metasploit remote code exploits for quick execution
* psfetch.sh
* fetch.sh
* autometerpreter.rc # resource for meterpreter to run after establish a session. It is generated from fetch.sh
* mass_smart.rc # resource to run for every meterpreter session

**Wrappers**

Wrapper to invoke tools such as medusa
* medusa.sh 

**Windows Command Line**


* domainbrute.bat # Command line script to perform intelligent bf attack


