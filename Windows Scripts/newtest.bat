::::::::::::::::::::::::::::::::::::::::::::
:: Automatically check & get admin rights V2
::::::::::::::::::::::::::::::::::::::::::::
@echo off
CLS
ECHO.
ECHO =============================
ECHO Running Admin shell
ECHO =============================

:init
setlocal DisableDelayedExpansion
set "batchPath=%~0"
for %%k in (%0) do set batchName=%%~nk
set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
setlocal EnableDelayedExpansion

:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
ECHO.
ECHO **************************************
ECHO Invoking UAC for Privilege Escalation
ECHO **************************************

ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
ECHO args = "ELEV " >> "%vbsGetPrivileges%"
ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
ECHO Next >> "%vbsGetPrivileges%"
ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
"%SystemRoot%\System32\WScript.exe" "%vbsGetPrivileges%" %*
exit /B

:gotPrivileges
setlocal & pushd .
cd /d %~dp0
if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

::::::::::::::::::::::::::::
::START
::::::::::::::::::::::::::::
MD %homedrive%\TEMPBBDVD\
CLS
TIMEOUT /T 1 >NUL
CLS
reg export HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile %homedrive%\TEMPBBDVD\regedit.reg
cls
timeout /t 3 >nul
cls
find '"EnableFirewall"=dword:00000001' %homedrive%\TEMPBBDVD\regedit.reg >nul
if %errorlevel% equ 1 goto disabled
goto blockmenu
cls

:disabled
cls
echo Firewall Is disabled
pause >nul
cls
del /q /f %homedrive%\TEMPBBDVD\regedit.reg >nul
cls
timeout /t 1 >nul
cls
RD %homedrive%\TEMPBBDVD\ >nul
cls
pause


:enabled
cls
echo Firewall is enabled
timeout /t 3 >nul
cls
timeout /t 1 >nul
timeout /t 5 >nul
cls
del /q /f %homedrive%\TEMPBBDVD\regedit.reg >nul
cls
timeout /t 1 >nul
goto Menu



:Menu

echo List of Ports that can be Blocked:
echo.
echo 1. FTP
echo 2. SSH
echo 3. TelNet
echo 4. SNMP
echo 5. LDAP
echo 6. RDP
echo 7. All of the Above
echo.
echo 8. Unblock Specific Ports
echo.
echo 9. Exit Window
echo.
echo.
set /p menu="Please Select the Port You Would Like to Block: (1-9)"
echo.
echo.
if %menu%==1 goto FTP
if %menu%==2 goto SSH
if %menu%==3 goto TelNet
if %menu%==4 goto SNMP
if %menu%==5 goto LDAP
if %menu%==6 goto RDP
if %menu%==7 goto All
if %menu%==8 goto UnblockMenu
if %menu%==9 goto Done



:FTP

netsh advfirewall firewall add rule name="Block FTP" protocol=TCP dir=out remoteport=21 action=block
netsh advfirewall firewall add rule name="Block FTP" protocol=TCP dir=in remoteport=21 action=block
echo.
ECHO FTP Port Blocked
goto Menu

:SSH

netsh advfirewall firewall add rule name="Block SSH" protocol=TCP dir=out remoteport=22 action=block
netsh advfirewall firewall add rule name="Block SSH" protocol=TCP dir=in remoteport=22 action=block
echo.
ECHO SSH Port Blocked
goto Menu

:TelNet

netsh advfirewall firewall add rule name="Block TelNet" protocol=TCP dir=out remoteport=23 action=block
netsh advfirewall firewall add rule name="Block TelNet" protocol=UDP dir=out remoteport=23 action=block
netsh advfirewall firewall add rule name="Block TelNet" protocol=TCP dir=in remoteport=23 action=block
netsh advfirewall firewall add rule name="Block TelNet" protocol=UDP dir=in remoteport=23 action=block
echo.
ECHO TelNet Port Blocked
goto Menu

:SNMP

netsh advfirewall firewall add rule name="Block SNMP" protocol=UDP dir=out remoteport=162 action=block
netsh advfirewall firewall add rule name="Block SNMP" protocol=TCP dir=out remoteport=162 action=block
netsh advfirewall firewall add rule name="Block SNMP" protocol=TCP dir=out remoteport=161 action=block
netsh advfirewall firewall add rule name="Block SNMP" protocol=UDP dir=in remoteport=162 action=block
netsh advfirewall firewall add rule name="Block SNMP" protocol=TCP dir=in remoteport=162 action=block
netsh advfirewall firewall add rule name="Block SNMP" protocol=TCP dir=in remoteport=161 action=block
echo.
ECHO SNMP Port Blocked
goto Menu
:LDAP

netsh advfirewall firewall add rule name="Block LDAP" protocol=TCP dir=out remoteport=389 action=block
netsh advfirewall firewall add rule name="Block LDAP" protocol=UDP dir=out remoteport=389 action=block
netsh advfirewall firewall add rule name="Block LDAP" protocol=TCP dir=in remoteport=389 action=block
netsh advfirewall firewall add rule name="Block LDAP" protocol=UDP dir=in remoteport=389 action=block
echo.
ECHO LDAP Port Blocked
goto Menu

:RDP

netsh advfirewall firewall add rule name="Block RDP" protocol=TCP dir=out remoteport=3389 action=block
netsh advfirewall firewall add rule name="Block RDP" protocol=UDP dir=out remoteport=3389 action=block
netsh advfirewall firewall add rule name="Block RDP" protocol=TCP dir=in remoteport=3389 action=block
netsh advfirewall firewall add rule name="Block RDP" protocol=UDP dir=in remoteport=3389 action=block
echo.
ECHO RDP Port Blocked
goto Menu

:All

netsh advfirewall firewall add rule name="Block RDP" protocol=TCP dir=out remoteport=3389 action=block
netsh advfirewall firewall add rule name="Block RDP" protocol=UDP dir=out remoteport=3389 action=block
netsh advfirewall firewall add rule name="Block RDP" protocol=TCP dir=in remoteport=3389 action=block
netsh advfirewall firewall add rule name="Block RDP" protocol=UDP dir=in remoteport=3389 action=block

netsh advfirewall firewall add rule name="Block LDAP" protocol=TCP dir=out remoteport=389 action=block
netsh advfirewall firewall add rule name="Block LDAP" protocol=UDP dir=out remoteport=389 action=block
netsh advfirewall firewall add rule name="Block LDAP" protocol=TCP dir=in remoteport=389 action=block
netsh advfirewall firewall add rule name="Block LDAP" protocol=UDP dir=in remoteport=389 action=block

netsh advfirewall firewall add rule name="Block SNMP" protocol=UDP dir=out remoteport=162 action=block
netsh advfirewall firewall add rule name="Block SNMP" protocol=TCP dir=out remoteport=162 action=block
netsh advfirewall firewall add rule name="Block SNMP" protocol=TCP dir=out remoteport=161 action=block
netsh advfirewall firewall add rule name="Block SNMP" protocol=UDP dir=in remoteport=162 action=block
netsh advfirewall firewall add rule name="Block SNMP" protocol=TCP dir=in remoteport=162 action=block
netsh advfirewall firewall add rule name="Block SNMP" protocol=TCP dir=in remoteport=161 action=block

netsh advfirewall firewall add rule name="Block TelNet" protocol=TCP dir=out remoteport=23 action=block
netsh advfirewall firewall add rule name="Block TelNet" protocol=UDP dir=out remoteport=23 action=block
netsh advfirewall firewall add rule name="Block TelNet" protocol=TCP dir=in remoteport=23 action=block
netsh advfirewall firewall add rule name="Block TelNet" protocol=UDP dir=in remoteport=23 action=block

netsh advfirewall firewall add rule name="Block SSH" protocol=TCP dir=out remoteport=22 action=block
netsh advfirewall firewall add rule name="Block SSH" protocol=TCP dir=in remoteport=22 action=block

netsh advfirewall firewall add rule name="Block FTP" protocol=TCP dir=out remoteport=21 action=block
netsh advfirewall firewall add rule name="Block FTP" protocol=TCP dir=in remoteport=21 action=block
echo.
ECHO Blocked Ports: FTP, RDP, LDAP, SNMP, Telnet, SSH, and FTP...
set /p unblock="Would You Like to UNBLOCK Any of These Ports? (Y/N)"
if %unblock%==Y goto UnblockMenu
if %unblock%==y goto UnblockMenu
if %unblock%==N goto Done
if %unblock%==n goto Done

:UnblockMenu

echo.
echo List of Ports that can be Unblocked:
echo.
echo 1. FTP
echo 2. SSH
echo 3. TelNet
echo 4. SNMP
echo 5. LDAP
echo 6. RDP
echo 7. All of the Above
echo.
echo 8. Block Specific Ports
echo.
echo 9. Exit Window
set /p menuA="Please Select the Port You Would Like to Unblock: (1-9)"
if %menuA%==1 goto FTP0
if %menuA%==2 goto SSH0
if %menuA%==3 goto TelNet0
if %menuA%==4 goto SNMP0
if %menuA%==5 goto LDAP0
if %menuA%==6 goto RDP0
if %menuA%==7 goto All0
if %menuA%==8 goto Menu
if %menuA%==9 goto Done




:FTP0

netsh advfirewall firewall add rule name="Block FTP" protocol=TCP dir=out remoteport=21 action=allow
netsh advfirewall firewall add rule name="Block FTP" protocol=TCP dir=in remoteport=21 action=allow
echo.
ECHO FTP Port Unblocked

goto UnblockMenu

:SSH0

netsh advfirewall firewall add rule name="Block SSH" protocol=TCP dir=out remoteport=22 action=allow
netsh advfirewall firewall add rule name="Block SSH" protocol=TCP dir=in remoteport=22 action=allow
echo.
ECHO SSH Port Unblocked
goto UnblockMenu

:TelNet0

netsh advfirewall firewall add rule name="Block TelNet" protocol=TCP dir=out remoteport=23 action=allow
netsh advfirewall firewall add rule name="Block TelNet" protocol=UDP dir=out remoteport=23 action=allow
netsh advfirewall firewall add rule name="Block TelNet" protocol=TCP dir=in remoteport=23 action=allow
netsh advfirewall firewall add rule name="Block TelNet" protocol=UDP dir=in remoteport=23 action=allow

echo.
ECHO TelNet Port Unblocked
goto UnblockMenu

:SNMP0

netsh advfirewall firewall add rule name="Block SNMP" protocol=UDP dir=out remoteport=162 action=allow
netsh advfirewall firewall add rule name="Block SNMP" protocol=TCP dir=out remoteport=162 action=allow
netsh advfirewall firewall add rule name="Block SNMP" protocol=TCP dir=out remoteport=161 action=allow
netsh advfirewall firewall add rule name="Block SNMP" protocol=UDP dir=in remoteport=162 action=allow
netsh advfirewall firewall add rule name="Block SNMP" protocol=TCP dir=in remoteport=162 action=allow
netsh advfirewall firewall add rule name="Block SNMP" protocol=TCP dir=in remoteport=161 action=allow
echo.
ECHO SNMP Port Unblocked
goto UnblockMenu

:LDAP0

netsh advfirewall firewall add rule name="Block LDAP" protocol=TCP dir=out remoteport=389 action=allow
netsh advfirewall firewall add rule name="Block LDAP" protocol=UDP dir=out remoteport=389 action=allow
netsh advfirewall firewall add rule name="Block LDAP" protocol=TCP dir=in remoteport=389 action=allow
netsh advfirewall firewall add rule name="Block LDAP" protocol=UDP dir=in remoteport=389 action=allow
echo.
ECHO LDAP Port Unblocked
goto UnblockMenu

:RDP0

netsh advfirewall firewall add rule name="Block RDP" protocol=TCP dir=out remoteport=3389 action=allow
netsh advfirewall firewall add rule name="Block RDP" protocol=UDP dir=out remoteport=3389 action=allow
netsh advfirewall firewall add rule name="Block RDP" protocol=TCP dir=in remoteport=3389 action=allow
netsh advfirewall firewall add rule name="Block RDP" protocol=UDP dir=in remoteport=3389 action=allow
echo.
ECHO RDP Port Unblocked
goto UnblockMenu

:All0

netsh advfirewall firewall add rule name="Block RDP" protocol=TCP dir=out remoteport=3389 action=allow
netsh advfirewall firewall add rule name="Block RDP" protocol=UDP dir=out remoteport=3389 action=allow

netsh advfirewall firewall add rule name="Block LDAP" protocol=TCP dir=out remoteport=389 action=allow
netsh advfirewall firewall add rule name="Block LDAP" protocol=UDP dir=out remoteport=389 action=allow

netsh advfirewall firewall add rule name="Block SNMP" protocol=UDP dir=out remoteport=162 action=allow
netsh advfirewall firewall add rule name="Block SNMP" protocol=TCP dir=out remoteport=162 action=allow
netsh advfirewall firewall add rule name="Block SNMP" protocol=TCP dir=out remoteport=161 action=allow

netsh advfirewall firewall add rule name="Block TelNet" protocol=TCP dir=out remoteport=23 action=allow
netsh advfirewall firewall add rule name="Block TelNet" protocol=UDP dir=out remoteport=23 action=allow

netsh advfirewall firewall add rule name="Block SSH" protocol=TCP dir=out remoteport=22 action=allow

netsh advfirewall firewall add rule name="Block FTP" protocol=TCP dir=out remoteport=21 action=allow

netsh advfirewall firewall add rule name="Block RDP" protocol=TCP dir=in remoteport=3389 action=allow
netsh advfirewall firewall add rule name="Block RDP" protocol=UDP dir=in remoteport=3389 action=allow

netsh advfirewall firewall add rule name="Block LDAP" protocol=TCP dir=in remoteport=389 action=allow
netsh advfirewall firewall add rule name="Block LDAP" protocol=UDP dir=in remoteport=389 action=allow

netsh advfirewall firewall add rule name="Block SNMP" protocol=UDP dir=in remoteport=162 action=allow
netsh advfirewall firewall add rule name="Block SNMP" protocol=TCP dir=in remoteport=162 action=allow
netsh advfirewall firewall add rule name="Block SNMP" protocol=TCP dir=in remoteport=161 action=allow

netsh advfirewall firewall add rule name="Block TelNet" protocol=TCP dir=in remoteport=23 action=allow
netsh advfirewall firewall add rule name="Block TelNet" protocol=UDP dir=in remoteport=23 action=allow

netsh advfirewall firewall add rule name="Block SSH" protocol=TCP dir=in remoteport=22 action=allow

netsh advfirewall firewall add rule name="Block FTP" protocol=TCP dir=in remoteport=21 action=allow
echo.
ECHO Unblocked Ports: FTP, RDP, LDAP, SNMP, Telnet, SSH, and FTP...
set /p block="Would You Like to BLOCK Any of These Ports? (Y/N)"
if %block%==Y goto Menu
if %block%==y goto Menu
if %block%==N goto Done
if %block%==n goto Done



:Done

set /p done="Are you sure you would like to exit? (Y/N)"
if %done%==Y goto Exit
if %done%==y goto Exit
if %done%==N goto Menu
if %done%==n goto Menu


:Exit
exit

