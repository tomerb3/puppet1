@echo off
for /F "tokens=1-10 delims=/ " %%i in ('date /t') do set logdate=%%k%%j%%i
for /F "tokens=1-5 delims=: " %%i in ('time /t') do set logtime=%%i%%j%%k
set datenow=%logdate%%logtime%

md "C:\Puppet_logs" 2>nul
if not exist "C:\Puppet_logs\*" (
    echo Failed to create directory "C:\Puppet_logs"
    pause
    goto :EOF
)

puppet apply --noop --environment production -l C:\Puppet_logs\puppet_dry_run_%datenow%.log C:\ProgramData\PuppetLabs\code\environments\production\manifests\site.pp

:EOF