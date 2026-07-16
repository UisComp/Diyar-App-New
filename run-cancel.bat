@echo off
cd /d "%~dp0"
echo Cancelling the stuck iOS run 28585363729...
gh run cancel 28585363729 --repo UisComp/Diyar-App-New
echo done (exit %errorlevel%)
pause
