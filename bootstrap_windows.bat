@echo off
TITLE HomeLab Windows Bootstrapper
echo Starting Windows environment configuration...

:: Runs PowerShell, bypassing the ExecutionPolicy for this process only.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0install_python_windows.ps1"

if %ERRORLEVEL% NEQ 0 (
	echo An error occurred during execution.
	pause
	exit /b %ERRORLEVEL%	
)

echo Bootstrap successfully completed.
pause

