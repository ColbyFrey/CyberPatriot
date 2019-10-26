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
echo.
cls
echo.
echo Welcome to the Port Blocker...s
echo.
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
echo.
set /p menu="Please Select the Port You Would Like to Block (1-7 in Order): (ex:1,2,4)"
if %menu%==1 goto 1
if %menu%==1,2 goto 1,2
if %menu%==1,2,3 goto 1,2,3
if %menu%==1,2,3,4 goto 1,2,3,4
if %menu%==1,2,3,4,5 goto 1,2,3,4,5
if %menu%==1,2,3,4,5,6 goto 7
if %menu%==1,2,3,4,5,6,7 goto 7
if %menu%==7 goto 7
if %menu%==1,2,3,4,6 goto 1,2,3,4,6
if %menu%==1,2,3,5,6
if %menu%==
if %menu%==
if %menu%==
if %menu%==
if %menu%==
if %menu%==
if %menu%==
if %menu%==
if %menu%==
if %menu%==
if %menu%==
if %menu%==
if %menu%==
if %menu%==


:1