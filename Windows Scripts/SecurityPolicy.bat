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
net accounts /MINPWLEN:8
echo password length set to 8
net accounts /MAXPWAGE:60
echo maximum password age set to 60 days
net accounts /MINPWAGE:5
echo minimum password age set to 5 days
net accounts /lockoutduration:30
echo Set Account Lockout Duration to 30 Minutes
net accounts /lockoutthreshold:5
echo Set Number of Bad Attemts to 5
net accounts /lockoutwindow:30
echo Set Account Lockout Counter Reset to 30 Minutes
secedit.exe /export /cfg C:\secconfig.cfg
cd /d C:\
powershell -Command "(gc secconfig.cfg) -replace 'PasswordComplexity = 0', 'PasswordComplexity = 1' -replace 'ClearTextPassword = 1', 'ClearTextPassword = 0' | Out-File secconfig.cfg"
pause
secedit.exe /configure /db %windir%\securitynew.sdb /cfg C:\secconfig.cfg /areas SECURITYPOLICY
del /Q C:\secconfig.cfg
ECHO password complexity enabled
cmd /k