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
copy "%~dp0\exclude.txt" C:\
cd /d C:\Users
subst Z: C:\Users
(Echo Pictures:
xcopy C:\Users\*.ani Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.bmp Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.cal Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.fax Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.gif Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.img Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.jbg Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.jpe Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.jpeg Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.jpg Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.mac Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.pbm Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.pcd Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.pcx Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.pct Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.pgm Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.png Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.ppm Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.psd Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.ras Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.tga Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.tiff Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.wmf Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
echo.
echo.
Echo Video Files:
xcopy C:\Users\*.mp4 Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.mpeg Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.mkv Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.flv Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.avi Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.mov Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.vob Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.wmv Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
echo.
echo.
Echo Audio Files:
xcopy C:\Users\*.aif Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.cda Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.mid Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.midi Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.mp3 Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.mpa Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.wav Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.ogg Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.wpl Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
xcopy C:\Users\*.wma Z:\ /E /L /Y /R /Exclude:C:\exclude.txt
echo.
echo.
Echo Programs:
xcopy C:\Users\*.exe Z:\ /E /L /Y /R /Exclude:C:\exclude.txt)> C:\Media-Excecutable_Files.txt

powershell -Command "(gc C:\Media-Excecutable_Files.txt) -replace '0 File(s)', '0' | Out-File C:\Media-Excecutable_Files.txt"
ECHO Picture Files Listed
ECHO Video Files Listed
ECHO Audio Files Listed
ECHO Programs Listed
echo.
echo.
echo.
cls
echo REMEMBER TO CHECK ALL OF THESE THINGS!!!!!!!!!
ECHO.
ECHO.
ECHO Press SpaceBar to Veiw the File Paths
pause
cd /d C:\
cd C:\
Media-Excecutable_Files.txt
subst z: /d
cmd /k