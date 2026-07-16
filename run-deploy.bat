@echo off
cd /d "%~dp0"
echo ==================================================
echo   Re-running TESTING deploy (secrets now in place)
echo ==================================================
gh run rerun 28574247792 --repo UisComp/Diyar-App-New
echo exit code %errorlevel%
echo.
echo Waiting a few seconds then listing testing runs...
timeout /t 10 >nul
gh run list --repo UisComp/Diyar-App-New --branch testing --limit 4
echo.
echo ==================================================
echo   The deploy is now running on GitHub Actions.
echo ==================================================
pause
