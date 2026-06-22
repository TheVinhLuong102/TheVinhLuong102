@echo off
REM Run as Administrator: enables OpenSSH Authentication Agent (Automatic + Start).
REM Delegates to auto-start-ssh.ps1 in this folder.
setlocal
set "SCRIPT_DIR=%~dp0"
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%auto-start-ssh.ps1"
set "EXITCODE=%ERRORLEVEL%"
endlocal & exit /b %EXITCODE%
