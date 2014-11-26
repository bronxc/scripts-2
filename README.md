README.md
=======
Collection of scripts which maybe helpful for engagements.
Made and should work in Kali.

Work in progress, some bad coding out there. :D

Setup.sh
======
Script to set up additional tools and dependencies on kali/debian based systems.
Useful for a quick out of the box deployment for Kali Linux on a physical machine or VM.

bind_metgen.sh
=====
Script to generate automatically bind meterpreter payloads from metasploit and
launch multihandler against target. Will move payload to /var/www and start apache for delivery

reverse_metgen.sh
=====
Same as above for reverse shell. Works better.

Scanning
=====
Self explanatory, scripts to invoke nikto, ssl and run scans against targets and ports, saving results separately
in a format ip.port.tool

ssl-cipher.sh
nikto-scan.sh

Metasploit
=====
