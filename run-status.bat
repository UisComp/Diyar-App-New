@echo off
cd /d "%~dp0"
echo ==================================================
echo   TESTING deploy - job status
echo ==================================================
gh run view 28574247792 --repo UisComp/Diyar-App-New
echo.
pause
